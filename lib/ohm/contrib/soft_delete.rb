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
    def self.included(base)
      base.attribute :deleted
      base.index :deleted
      base.extend ClassMethods
    end

    def delete
      update(:deleted => "1")
    end

    def deleted?
      deleted == "1"
    end

    private

    def create_model_membership
      self.class.all_including_deleted << self
    end

    def delete_model_membership
      key.del
      self.class.all_including_deleted.delete(self)
    end

    module ClassMethods
      def all_including_deleted
        Ohm::Model::Index.new(key[:all], Ohm::Model::Wrapper.wrap(self))
      end

      def all
        all_including_deleted.except(:deleted => "1")
      end
    end
  end
end
