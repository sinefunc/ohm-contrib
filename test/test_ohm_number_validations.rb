require "helper"

class TestOhmNumberValidations < Test::Unit::TestCase
  class Product < Ohm::Model
    include Ohm::NumberValidations

    attribute :price
    attribute :optional_price

    def validate
      assert_decimal :price
      assert_decimal :optional_price unless optional_price.to_s.empty?
    end
  end

  context "given no price" do
    should "still validate as :not_decimal" do
      product = Product.new(:price => nil)
      product.valid?

      assert_equal [[:price, :not_decimal]], product.errors
    end
  end

  context "given a 0.10 value" do
    should "validate as a decimal" do
      product = Product.new(:price => 0.10)

      assert product.valid?
    end
  end

  context "given 1 as a value" do
    should "validate as a decimal" do
      product = Product.new(:price => 1)

      assert product.valid?
    end
  end

  context "given 1 dot as a value" do
    should "not validate as a decimal" do
      product = Product.new(:price => "1.")

      assert ! product.valid?
      assert_equal [[:price, :not_decimal]], product.errors
    end
  end

  context "given no value for optional price" do
    should "have no validation errors" do
      product = Product.new(:price => 10.1, :optional_price => nil)
      assert product.valid?

      product = Product.new(:price => 10.1, :optional_price => '')
      assert product.valid?
    end
  end
end