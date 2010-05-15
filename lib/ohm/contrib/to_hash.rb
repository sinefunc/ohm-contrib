module Ohm
  module ToHash
    def to_hash
      atts = attributes + counters
      hash = atts.inject({}) { |h, att| h[att] = send(att); h }
      hash[:id] = @id
      hash
    end
    alias :to_h :to_hash
  end
end