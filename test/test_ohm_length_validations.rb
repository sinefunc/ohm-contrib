require "helper"

class LengthValidationsTest < Test::Unit::TestCase
  describe "length validation with a normal string column" do
    class Person < Ohm::Model
      include Ohm::LengthValidations

      attribute :name
      
      def validate
        assert_min_length :name, 5
        assert_max_length :name, 10
      end
    end

    test "valid length name" do
      assert Person.new(:name => "bob smith").valid?
    end

    test "also catches short strings" do
      assert ! Person.new(:name => "bob").valid?
    end

    test "also catches long strings" do
      assert ! Person.new(:name => "robert smithson").valid?
    end

    test "invalid when empty" do
      assert ! Person.new(:name => "").valid?
    end
  end
end
