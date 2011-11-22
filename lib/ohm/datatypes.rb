require "bigdecimal"
require "date"
require "json"
require "time"

module Ohm
  module DataTypes
    def self.included(model)
      model.extend ClassMethods
    end

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
        attribute(att, lambda { |t| t && (t.kind_of?(Time) ? t : Time.parse(t)) })
      end

      def Date(att)
        attribute(att, lambda { |d| d && (d.kind_of?(Date) ? d : Date.parse(d)) })
      end

      def UnixTime(att)
        attribute(att, lambda { |t| t && UnixTime.at(t.to_i) })
      end

      def Hash(att)
        attribute(att, lambda { |h| h && (h.kind_of?(Hash) ? SerializedHash[h] : JSON(h)) })
      end

      def Array(att)
        attribute(att, lambda { |a| a && (a.kind_of?(Array) ? SerializedArray.new(a) : JSON(a)) })
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