module Ohm
  # Ohm has already added its own `to_hash` method. The difference
  # is that it chose the albeit better whitelisted approach.
  #
  # @example
  #
  #   # this is the core Ohm#to_hash implementation
  #   class Post < Ohm::Model
  #     attribute :body
  #     def validate
  #       assert_present :body
  #     end
  #   end
  #
  #   Post.create.to_hash == { :errors => [[:body, :not_present]] }
  #   # => true
  #
  #   Post.create(:body => "The body").to_hash == { :id => 1 }
  #   # => true
  #
  #   # now this is the all-in-one (kinda Railsy) method.
  #   class Post < Ohm::Model
  #     attribute :body
  #   end
  #
  #   Post.create(:body => "Body").to_hash == { :id => 1, :body => "Body" }
  #   # => true
  #
  # @todo use super when Ohm has finally release their #to_hash impl.
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
