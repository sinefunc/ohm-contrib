require 'helper'

class TestOhmContrib < Test::Unit::TestCase
  test "autoloading of Boundaries" do
    assert_nothing_raised NameError, LoadError do
      Ohm::Boundaries
    end
  end

  test "autoloading of timestamping" do
    assert_nothing_raised NameError, LoadError do
      Ohm::Timestamping
    end
  end

  test "autoloading of ToHash" do
    assert_nothing_raised NameError, LoadError do
      Ohm::ToHash
    end
  end

  test "autoloading of WebValidations" do
    assert_nothing_raised NameError, LoadError do
      Ohm::WebValidations
    end
  end

  test "autoloading of NumberValidations" do
    assert_nothing_raised NameError, LoadError do
      Ohm::NumberValidations
    end
  end

  test "autoloading of Typecast" do
    assert_nothing_raised NameError, LoadError do
      Ohm::Typecast
    end
  end
end