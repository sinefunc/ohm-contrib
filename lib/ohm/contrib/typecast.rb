require 'bigdecimal'
require 'time'
require 'date'

module Ohm
  # Provides all the primitive types. The following are included:
  #
  # * String
  # * Decimal
  # * Integer
  # * Float
  # * Date
  # * Time
  module Types
    def self.defined?(type)
      @constants ||= constants.map(&:to_s)
      @constants.include?(type.to_s)
    end

    def self.[](type)
      const_get(type.to_s.split('::').last)
    end

    class Primitive < BasicObject
      def initialize(value)
        @raw = value
      end

      def to_s
        @raw.to_s
      end

      def inspect
        object
      end

      def ==(other)
        to_s == other.to_s
      end

    protected
      def object
        @raw
      end

      def method_missing(meth, *args, &blk)
        object.send(meth, *args, &blk)
      end
    end

    class String < Primitive
    end

    class Decimal < Primitive
      def inspect
        object.to_s('F')
      end

    protected
      def object
        ::Kernel::BigDecimal(@raw)
      end
    end

    class Integer < Primitive
    protected
      def object
        ::Kernel::Integer(@raw)
      end
    end

    class Float < Primitive
    protected
      def object
        ::Kernel::Float(@raw)
      end
    end

    class Time < Primitive
    protected
      def object
        ::Time.parse(@raw)
      end
    end

    class Date < Primitive
    protected
      def object
        ::Date.parse(@raw)
      end
    end
  end

  # Provides unobtrusive, non-explosive typecasting.Instead of exploding on set
  # of an invalid value, this module takes the approach of just taking in
  # parameters and letting you do validation yourself. The only thing this
  # module does for you is the boilerplate casting you might need to do.
  #
  # @example
  #
  #   # without typecasting
  #   class Item < Ohm::Model
  #     attribute :price
  #     attribute :posted
  #   end
  #
  #   item = Item.create(:price => 299, :posted => Time.now.utc)
  #   item = Item[item.id]
  #
  #   # now when you try and grab `item.price`, its a string.
  #   "299" == item.price
  #   # => true
  #
  #   # you can opt to manually cast everytime, or do it in the model, i.e.
  #
  #   class Item
  #     def price
  #       BigDecimal(read_local(:price))
  #     end
  #   end
  #
  # The Typecasted way
  # ------------------
  #
  #   class Item < Ohm::Model
  #     include Ohm::Typecast
  #
  #     attribute :price, Decimal
  #     attribute :posted, Time
  #   end
  #
  #   item = Item.create(:price => "299", :posted => Time.now.utc)
  #   item = Item[item.id]
  #   item.price.class == Ohm::Types::Decimal
  #   # => true
  #
  #   item.price.to_s == "299"
  #   # => true
  #
  #   item.price * 2 == 598
  #   # => true
  #
  #   item.posted.strftime('%m/%d/%Y')
  #   # => works!!!
  module Typecast
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      # Defines a typecasted attribute.
      #
      # @example
      #   
      #   class User < Ohm::Model
      #     include Ohm::Typecast
      #
      #     attribute :birthday, Date
      #     attribute :last_login, Time
      #     attribute :age, Integer
      #     attribute :spending, Decimal
      #     attribute :score, Float
      #   end
      #
      #   user = User.new(:birthday => "2000-01-01")
      #   user.birthday.month == 1
      #   # => true
      #
      #   user.birthday.year == 2000
      #   # => true
      #
      #   user.birthday.day == 1
      #   # => true
      #
      #   user = User.new(:age => 20)
      #   user.age - 1 == 19
      #   => true
      # 
      # @param [Symbol] name the name of the attribute to define.
      # @param [Class] type (defaults to Ohm::Types::String) a class defined in 
      #                Ohm::Types. You may define custom types in Ohm::Types if
      #                you need to.
      # @return [Array] the array of attributes already defined.
      # @return [nil] if the attribute is already defined.
      def attribute(name, type = Ohm::Types::String, klass = Ohm::Types[type])
        define_method(name) do
          value = read_local(name)
          value && klass.new(value)
        end

        define_method(:"#{name}=") do |value|
          write_local(name, value && value.to_s)
        end

        attributes << name unless attributes.include?(name)
      end

    private
      def const_missing(name)
        if Ohm::Types.defined?(name)
          Ohm::Types[name]
        else
          super
        end
      end
    end
  end
end
