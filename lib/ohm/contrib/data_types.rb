require "bigdecimal"
require "date"
require "json"
require "time"

module Ohm
  module DataTypes
    module ClassMethods
      def String(att)
        attribute(att) 
      end

      def Integer(att)
        attribute(att, lambda { |x| x.to_i })
      end

      def Decimal(att)
        attribute(att, lambda { |x| x && BigDecimal(x.to_s) })
      end

      def Float(att)
        attribute(att, lambda { |x| x.to_f })
      end
  
      def Boolean(att)
        attribute(att, lambda { |x| !!x })

        alias_method :"#{att}?", att
      end

      def Time(att)
        attribute(att, lambda { |t| t.respond_to?(:to_str) ? Time.parse(t) : t })
      end

      def Date(att)
        attribute(att, lambda { |d| d.respond_to?(:to_str) ? Date.parse(d) : d })
      end
  
      def UnixTime(att)
        attribute(att, lambda { |t| t && UnixTime.at(t.to_i) })
      end

      def Hash(att)
        attribute(att, serialized_json { |val| SerializedHash[val] })
      end

      def Array(att)
        attribute(att, serialized_json { |val| SerializedArray.new(val) })
      end

    private
      def serialized_json(&blk)
        lambda { |v| v && (v.respond_to?(:to_str) ? JSON(v) : blk.call(v)) }
      end
    end

    class UnixTime < Time
      def to_s
        to_i.to_s
      end
    end
  
    class SerializedHash < Hash
      def to_s
        JSON.dump(self)
      end
    end

    class SerializedArray < Array
      def to_s
        JSON.dump(self)
      end
    end
  end
end
