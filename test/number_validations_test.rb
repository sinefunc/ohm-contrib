# encoding: UTF-8

require File.expand_path("./helper", File.dirname(__FILE__))

class Product < Ohm::Model
  include Ohm::NumberValidations

  attribute :price
  attribute :optional_price

  def validate
    assert_decimal :price
    assert_decimal :optional_price unless optional_price.to_s.empty?
  end
end

test "has error when empty" do
  product = Product.new(:price => nil)
  product.valid?

  assert [[:price, :not_decimal]] == product.errors
end

test "validation scenarios" do
  assert Product.new(:price => 0.10).valid?
  assert Product.new(:price => 1).valid?

  p = Product.new(:price => '1.')
  assert ! p.valid?
  assert [[:price, :not_decimal]] == p.errors
end

test "allows empty values through basic ruby conditions" do
  assert Product.new(:price => 10.1, :optional_price => nil).valid?
  assert Product.new(:price => 10.1, :optional_price => '').valid?
end

