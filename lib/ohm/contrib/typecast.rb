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
      ASSERTION = :assert_type_time

      def self.[](value)
        return value if value.to_s.empty?

        ret = parse(value)
        ret.to_s == value ? ret : value
      end
    end

    class Date < ::Date
      ASSERTION = :assert_type_date

      def self.[](value)
        return value if value.to_s.empty?

        parse(value)
      rescue ArgumentError
        value
      end
    end

    class Decimal < BigDecimal
      ASSERTION = :assert_type_decimal
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
      ASSERTION = :assert_type_float

      def self.[](value)
        return value if value.to_s.empty?

        Float(value)
      rescue ArgumentError
        value
      end
    end

    class Integer < ::Integer
      ASSERTION = :assert_type_integer

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
    class MissingValidation < StandardError
      MESSAGE = "%s :%s is required in your #validate method"

      attr :field
      attr :assertion

      def initialize(field, assertion)
        @field, @assertion = field, assertion
      end

      def message
        MESSAGE % [assertion, field]
      end
    end

    include Types
    include TypeAssertions
    
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def attribute(name, type = Ohm::Types::String, assertion = defined?(type::ASSERTION) ? type::ASSERTION : nil)
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
        types[name] = [type, assertion] unless types.has_key?(name)
      end
      
      def types
        @types ||= {}
      end
    end

    def valid?
      return unless super

      self.class.types.each do |field, (type, assertion)|
        value = send(field)
        
        unless value.kind_of?(type)
          raise MissingValidation.new(field, assertion)
        end
      end
    end

    def validate
      self.class.types.each do |field, (type, assertion)|
        send assertion, field  if assertion
      end
    end
  end
end
