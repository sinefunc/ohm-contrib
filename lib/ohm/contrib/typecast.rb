require 'bigdecimal'
require 'time'
require 'date'

module Ohm
  module Types
    class String < ::String
      def self.[](value)
        value
      end
    end

    class Time < ::Time
      def self.[](value)
        return value if value.to_s.empty?

        ret = parse(value)
        ret.to_s == value ? ret : value
      end
    end

    class Date < ::Date
      def self.[](value)
        return value if value.to_s.empty?

        parse(value)
      rescue ArgumentError
        value
      end
    end

    class Decimal
      CANONICAL = /^(\d+)?(\.\d+)?(E[+\-]\d+)?$/

      def self.[](value)
        return value if value.to_s.empty?

        if value.to_s =~ CANONICAL
          BigDecimal(value)
        else
          value
        end
      end
    end

    class Float < ::Float
      def self.[](value)
        return value if value.to_s.empty?

        Float(value)
      rescue ArgumentError
        value
      end
    end

    class Integer < ::Integer
      def self.[](value)
        return value if value.to_s.empty?

        Integer(value)
      rescue ArgumentError
        value
      end
    end
  end

  module Typecast
    include Types

    def self.included(base)
      base.extend Macros
    end

    module Macros
      def attribute(name, type = String)
        define_method(name) do
          type[read_local(name)]
        end

        define_method(:"#{name}=") do |value|
          write_local(name, value && value.to_s)
        end

        attributes << name unless attributes.include?(name)
      end
    end
  end
end