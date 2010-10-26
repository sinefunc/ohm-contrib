module Ohm
  # Provides support for soft deletion
  #
  # @example
  #
  #   class Post < Ohm::Model
  #     include Ohm::SoftDelete
  #
  #     attribute :title
  #     index :title
  #   end
  #
  #   post = Post.create(:title => 'Title')
  #
  #   post.deleted?
  #   # => false
  #
  #   post.delete
  #
  #   post.deleted?
  #   # => true
  #
  #   Post.all.empty?
  #   # => true
  #
  #   Post.find(:title => 'Title').empty?
  #   # => true
  #
  #   Post.exists?(post.id)
  #   # => true
  #
  #   post = Post[post.id]
  #
  #   post.deleted?
  #   # => true
  module SoftDelete
    IS_DELETED = "1"

    def self.included(base)
      base.attribute :deleted
      base.index :deleted
      base.extend ClassMethods
    end

    def delete
      update(:deleted => IS_DELETED)
    end

    def deleted?
      deleted == IS_DELETED
    end

  private
    def create_model_membership
      self.class.key[:all].sadd(self.id)
    end

    def delete_model_membership
      key.del
      self.class.key[:all].srem(self.id)
    end

    module ClassMethods
      def all
        super.except(:deleted => IS_DELETED)
      end
    end
  end
end