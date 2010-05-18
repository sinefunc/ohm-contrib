require 'bigdecimal'
require 'time'
require 'date'
require 'forwardable'

module Ohm
  module Types
    class Primitive < BasicObject
      def initialize(value)
        @raw = value
      end

      def to_s
        @raw
      end

      def inspect
        "#<Primitive raw=#{@raw}>"
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
