module Ohm
  module Boundaries
    def self.included(base)
      base.extend ClassMethods 
    end

    module ClassMethods
      def first
        all.first
      end

      def last
        self[db.get(key(:id))]
      end
    end
  end
end
