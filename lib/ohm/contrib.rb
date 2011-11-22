require_relative "contrib/plugin"

module Ohm
  module Contrib
    VERSION = "0.1.2"
  end

  class Model
    extend Plugin
  end
end