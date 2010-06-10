require "helper"

class OhmExtraValidationsTest < Test::Unit::TestCase
  context "membership assertion" do
    class Order < Ohm::Model
      include Ohm::ExtraValidations

      attribute :state

      def validate
        assert_member :state, %w(pending authorized declined)
      end
    end

    should "be successful given all the members" do
      order = Order.new(:state => 'pending')
      assert order.valid?

      order = Order.new(:state => 'authorized')
      assert order.valid?

      order = Order.new(:state => 'declined')
      assert order.valid?
    end

    should "fail on a non-member" do
      order = Order.new(:state => 'foobar')
      assert ! order.valid?
      assert_equal [[:state, :not_member]], order.errors
    end
  end
end
