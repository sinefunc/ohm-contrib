module Ohm
  module Versioned
    def self.included(model)
      model.attribute :_version, lambda { |x| x.to_i }
    end

    def save!
      super do |t|
        t.read do |store|
          current_version = key.hget(:_version).to_i

          if current_version != _version
            raise Ohm::VersionConflict.new(attributes)
          end

          self._version = current_version + 1
        end

        yield t if block_given?
      end
    end
  end

  class VersionConflict < StandardError
    attr :attributes

    def initialize(attributes)
      @attributes = attributes
    end
  end
end
