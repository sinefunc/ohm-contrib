require 'rubygems'
require 'test/unit'
require 'contest'
require 'redis'
require 'ohm'
require 'timecop'
require 'mocha'

Ohm.connect :host => "localhost", :port => "6379"

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'ohm/contrib'

class Test::Unit::TestCase
end
