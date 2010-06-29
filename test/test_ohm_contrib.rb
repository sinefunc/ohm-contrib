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

  test "autoloading of Locking" do
    assert_nothing_raised NameError, LoadError do
      Ohm::Locking
    end
  end

  test "autoloading of ExtraValidations" do
    assert_nothing_raised NameError, LoadError do
      Ohm::ExtraValidations
    end
  end

  test "autoloading of DateValidations" do
    assert_nothing_raised NameError, LoadError do
      Ohm::DateValidations
    end
  end

  test "autoloading of LunarMacros" do
    require 'lunar'
    assert_nothing_raised NameError, LoadError do
      Ohm::LunarMacros
    end
  end

  test "autoloading of Slug" do
    assert_nothing_raised NameError, LoadError do
      Ohm::Slug
    end
  end
end
