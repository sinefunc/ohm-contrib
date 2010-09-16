# encoding: UTF-8

require File.expand_path("./helper", File.dirname(__FILE__))

test "autoloading of all libraries" do
  assert_nothing_raised NameError, LoadError do
    Ohm::Boundaries
    Ohm::Timestamping
    Ohm::WebValidations
    Ohm::NumberValidations
    Ohm::Typecast
    Ohm::Locking
    Ohm::ExtraValidations
    Ohm::DateValidations
    Ohm::LunarMacros
    Ohm::Slug
  end
end

