require 'cutest'
require 'redis'
require 'ohm'
require 'ohm/contrib'
require 'override'

Ohm.connect :host => "localhost", :port => 6379, :db => 1

NOW = Time.utc(2010, 5, 12)

include Override

prepare {
  Ohm.flush
  override(Time, :now => NOW)
}

def assert_nothing_raised(*exceptions)
  begin
    yield
  rescue *exceptions
    flunk(caller[1])
  end
end

