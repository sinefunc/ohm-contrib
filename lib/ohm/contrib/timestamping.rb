module Ohm
  module Timestamping
    def self.included(base)
      base.attribute :created_at
      base.attribute :updated_at
    end
    
    def create
      self.created_at ||= Time.now.utc

      super
    end

  protected
    def write
      self.updated_at ||= Time.now.utc

      super
    end
  end
end
