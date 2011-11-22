module Ohm
  # Provides created_at / updated_at timestamps.
  #
  # @example
  #
  #   class Post < Ohm::Model
  #     include Ohm::Timestamping
  #   end
  #
  #   post = Post.create
  #   post.created_at.to_s == Time.now.utc.to_s
  #   # => true
  #
  #   post = Post[post.id]
  #   post.save
  #   post.updated_at.to_s == Time.now.utc.to_s
  #   # => true
  module Timestamping
    def self.setup(model)
      model.plugin :callbacks
      model.plugin :datatypes

      model.UnixTime :created_at
      model.UnixTime :updated_at

      model.before :create, :set_created_at
      model.before :save,   :set_updated_at
    end

  protected
    def set_created_at
      self.created_at ||= Time.now.utc.to_i
    end

    def set_updated_at
      self.updated_at = Time.now.utc.to_i
    end
  end
end