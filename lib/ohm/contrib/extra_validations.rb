module Ohm
  # Includes Ohm::NumberValidations and Ohm::WebValidations.
  #
  # @example
  #
  #   class Post < Ohm::Model
  #     include Ohm::ExtraValidations
  #
  #     attribute :price
  #     attribute :state
  #     attribute :slug
  #     attribute :author_email
  #     attribute :url
  #     attribute :ipaddr
  #
  #     def validate
  #       super
  #
  #       assert_decimal :price
  #       assert_member  :state, ['published', 'unpublished']
  #       assert_ipaddr  :ipaddr
  #       assert_url     :url
  #       assert_email   :author_email
  #     end
  #   end
  #
  #   post = Post.new
  #   post.valid?
  #   post.errors
  #   # [[:price, :not_decimal], [:state, :not_member], [:ipaddr, :not_ipaddr],
  #   #  [:url, :not_url], [:author_email, :not_email]]
  module ExtraValidations
    include NumberValidations
    include WebValidations

  protected
    def assert_member(att, set, error = [att, :not_member])
      assert set.include?(send(att)), error
    end
  end
end