module Ohm
  # Provides support for soft deletion
  #
  # @example
  #
  #   class Post < Ohm::Model
  #     plugin :softdelete
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
  #   Post.find(:title => 'Title').include?(post)
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
    DELETED_FLAG = "1"

    def self.included(model)
      model.attribute :deleted

      model.extend ClassMethods
    end

    def delete
      self.class.all.delete(self)
      self.class.deleted.add(self)

      update(deleted: DELETED_FLAG)
    end

    def restore
      self.class.all.add(self)
      self.class.deleted.delete(self)

      update(deleted: nil)
    end

    def deleted?
      deleted == DELETED_FLAG
    end

    module ClassMethods
      def deleted
        Model::Set.new(key[:deleted], Model::Wrapper.wrap(self))
      end

      def exists?(id)
        super || key[:deleted].sismember(id)
      end
    end
  end
end