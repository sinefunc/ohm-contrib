module Ohm
  # Dirt cheap ::first and ::last support.
  #
  # @example
  #
  #   class Post < Ohm::Model
  #     include Ohm::Boundaries
  #   end
  #
  #   post1 = Post.create
  #   post2 = Post.create
  #   post1 == Post.first
  #   # => true
  #
  #   post2 == Post.last
  #   # => true
  module Boundaries
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def first(opts = {})
        if opts.any?
          find(opts).first
        else
          all.first(opts)
        end
      end

      def last(opts = {})
        if opts.any?
          find(opts).first(:order => "DESC")
        else
          all.first(:order => "DESC")
        end
      end
    end
  end
end

