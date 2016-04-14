require_relative "helper"
require_relative "../lib/ohm/contrib"

test "plugins" do
  assert defined?(Ohm::Callbacks)
  assert defined?(Ohm::DataTypes)
  assert defined?(Ohm::Locking)
  assert defined?(Ohm::Scope)
  assert defined?(Ohm::Slug)
  assert defined?(Ohm::SoftDelete)
  assert defined?(Ohm::Timestamps)
  assert defined?(Ohm::Versioned)
end
