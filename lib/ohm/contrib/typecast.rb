require 'bigdecimal'
require 'time'
require 'date'

module Ohm
  module Types
    class String < ::String
      def self.[](value)
        new(value)
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

    class Decimal < BigDecimal
      CANONICAL = /^(\d+)?(\.\d+)?(E[+\-]\d+)?$/

      def self.[](value)
        return value if value.to_s.empty?

        if value.to_s =~ CANONICAL
          new(value)
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
  
  module TypeAssertions

  protected
    def assert_type_decimal(att, error = [att, :not_decimal])
      assert send(att).is_a?(Ohm::Types::Decimal), error
    end

    def assert_type_time(att, error = [att, :not_time])
      assert send(att).is_a?(Ohm::Types::Time), error 
    end

    def assert_type_date(att, error = [att, :not_date])
      assert send(att).is_a?(Ohm::Types::Date), error 
    end

    def assert_type_integer(att, error = [att, :not_integer])
      assert send(att).is_a?(Ohm::Types::Integer), error
    end

    def assert_type_float(att, error = [att, :not_float])
      assert send(att).is_a?(Ohm::Types::Float), error
    end
  end

  module Typecast
    MissingValidation = Class.new(StandardError)

    include Types
    include TypeAssertions
    
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def attribute(name, type = Ohm::Types::String)
        define_method(name) do
          type[read_local(name)]
        end

        define_method(:"#{name}=") do |value|
          if type.respond_to?(:dump)
            write_local(name, type.dump(value))
          else
            write_local(name, value && value.to_s)
          end
        end

        attributes << name unless attributes.include?(name)
        types[name] = type unless types.has_key?(name)
      end
      
      def types
        @types ||= {}
      end
    end

    def valid?
      return unless super

      self.class.types.each do |field, type|
        value = send(field)
        assertion = 'assert_type_%s' % type.name.split('::').last.downcase
        
        unless value.kind_of?(type)
          raise MissingValidation, 
            "#{ assertion } :#{ field} is required in your #validate method"
        end
      end
    end
  end
end
