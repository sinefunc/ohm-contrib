require_relative "helper"
require_relative "../lib/ohm/locking"

class Server < Ohm::Model
  include Ohm::Locking
  extend Ohm::Locking

  attribute :taken
  index :taken

  def self.acquire
    spinlock do
      s = Server.find(taken: 0).first

      if s
        s.update(taken: 1)
      end

      return s
    end
  end
end

test "mutex method is added at instance and class level" do
  assert Server.new.respond_to?(:spinlock)
end

test "acquire with concurrency" do
  s = Server.create(taken: 0)

  res = {}

  threads = 5.times.map do |i|
    Thread.new(i, res) do |idx, e|
      e[idx] = Server.acquire
    end
  end

  threads.each(&:join)

  assert_equal 1, res.values.compact.size
end
