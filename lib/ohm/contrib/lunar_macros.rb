begin
  require 'lunar'
rescue LoadError
  raise "You have to install Lunar in order to use Ohm::LunarMacros."
end

module Ohm
  module LunarMacros
    def self.included(base)
      base.send  :include, Ohm::Callbacks
      base.after :save,   :update_lunar_index
      base.after :delete, :delete_lunar_index

      base.extend ClassMethods
    end

    module ClassMethods
      def fuzzy(*atts)    lunar_fields(:fuzzy,    *atts) end
      def text(*atts)     lunar_fields(:text,     *atts) end
      def number(*atts)   lunar_fields(:number,   *atts) end
      def sortable(*atts) lunar_fields(:sortable, *atts) end
    
      def lunar_fields(type, *atts)
        @lunar_fields ||= Hash.new { |h, k| h[k] = [] }

        atts.each { |att| 
          @lunar_fields[type] << att  unless @lunar_fields[type].include?(att)
        }

        @lunar_fields[type]
      end
    end

    def update_lunar_index
      Lunar.index self.class do |i|
        i.id id
        
        [:fuzzy, :text, :number, :sortable].each do |type|
          self.class.lunar_fields(type).each do |field|
            value = send(field)
            
            if type == :text and value.kind_of?(Enumerable)
              i.text field, value.join(' ')  unless value.empty?
            else
              i.send type, field, value  unless value.to_s.empty?
            end
          end
        end
      end
    end

  protected
    def delete_lunar_index
      Lunar.delete self.class, id
    end
  end
end
