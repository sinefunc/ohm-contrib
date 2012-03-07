require_relative "datatypes"
require_relative "callbacks"

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
    def self.included(model)
      model.send :include, Ohm::Callbacks

      model.attribute :created_at, DataTypes::Type::Timestamp
      model.attribute :updated_at, DataTypes::Type::Timestamp

      model.before :create, :initialize_created_at
      model.before :save,   :initialize_updated_at
    end

  protected
    def initialize_created_at
      self.created_at ||= Time.now.utc.to_i
    end

    def initialize_updated_at
      self.updated_at = Time.now.utc.to_i
    end
  end
end
