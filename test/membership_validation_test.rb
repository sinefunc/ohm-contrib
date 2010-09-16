# encoding: UTF-8

require File.expand_path("./helper", File.dirname(__FILE__))

class Order < Ohm::Model
  include Ohm::ExtraValidations

  attribute :state

  def validate
    assert_member :state, %w(pending authorized declined)
  end
end

test "validates for all members" do
  order = Order.new(:state => 'pending')
  assert order.valid?

  order = Order.new(:state => 'authorized')
  assert order.valid?

  order = Order.new(:state => 'declined')
  assert order.valid?
end

test "fails on a non-member" do
  order = Order.new(:state => 'foobar')
  assert ! order.valid?
  assert [[:state, :not_member]] == order.errors
end

