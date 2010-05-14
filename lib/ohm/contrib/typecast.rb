require 'bigdecimal'
require 'time'
require 'date'

module Ohm
  module Typecast
    def self.included(base)
      base.extend Macros 
    end

    module Macros
      def attribute(name, type = :string)
        define_method(name) do
          typecast(read_local(name), type)
        end

        define_method(:"#{name}=") do |value|
          write_local(name, value && value.to_s)
        end

        attributes << name unless attributes.include?(name)
      end
    end

  protected
    def typecast(val, type)
      return val if val.to_s.empty?

      case type
      when :integer then Integer(val)
      when :float   then Float(val)
      when :decimal then BigDecimal(val)
      when :time    
        ret = Time.parse(val)
        ret.to_s == val ? ret : val

      when :date    then Date.parse(val)
      when :string  then val
      end
  
    # All of the casting methods used above raises an ArgumentError
    # if it fails to parse the value properly. If this happens,
    # the least surprising behavior is to return the original value
    rescue ArgumentError
      val
    end
  end
end
