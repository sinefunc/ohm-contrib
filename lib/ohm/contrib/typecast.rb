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
    include Types

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def attribute(name, type = Ohm::Types::String)
        define_method(name) do
          value = read_local(name)
          value && type.new(value)
        end

        define_method(:"#{name}=") do |value|
          write_local(name, value && value.to_s)
        end

        attributes << name unless attributes.include?(name)
      end
    end
  end
end
