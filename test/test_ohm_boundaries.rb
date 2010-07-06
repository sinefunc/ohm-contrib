require "helper"

class TestOhmBoundaries < Test::Unit::TestCase
  setup do
    Ohm.flush
  end

  class Person < Ohm::Model
    include Ohm::Boundaries

    attribute :name
    index :name
  end

  context "when there are no People" do
    should "have a nil Person.first" do
      assert_nil Person.first
    end

    should "have a nil Person.last" do
      assert_nil Person.last
    end
  end

  context "after creating a single Person named matz" do
    setup do
      @matz = Person.create(:name => "matz")
    end

    should "have matz as the first person" do
      assert_equal @matz, Person.first
    end

    should "have matz as the last person" do
      assert_equal @matz, Person.last
    end
  end

  context "after creating matz first then linus next" do
    setup do
      @matz  = Person.create(:name => "matz")
      @linus = Person.create(:name => "linus")
    end

    should "have matz as the first Person" do
      assert_equal @matz, Person.first
    end

    should "have linus as the last Person" do
      assert_equal @linus, Person.last
    end

    context "when searching name => matz" do
      test "matz is the first and last" do
        assert_equal @matz, Person.first(:name => "matz")
        assert_equal @matz, Person.last(:name => "matz")
      end
    end

    context "when searching name => linus" do
      test "linus is first and last" do
        assert_equal @linus, Person.first(:name => "linus")
        assert_equal @linus, Person.last(:name => "linus") 
      end
    end

    context "when searching name => quentin" do
      should "have nil as first and last" do
        assert_nil Person.first(:name => "quentin")
        assert_nil Person.last(:name => "quentin")       
      end
    end
  end
end
