require "cutest"
require "ohm"
require "override"

NOW = Time.utc(2010, 5, 12)

include Override

prepare do
  Ohm.flush
  override(Time, now: NOW)
end

def assert_nothing_raised(*exceptions)
  begin
    yield
  rescue *exceptions
    flunk(caller[1])
  end
end
