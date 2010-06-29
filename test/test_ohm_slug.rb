require "helper"

class OhmSlugTest < Test::Unit::TestCase
  module Finder
    def [](id)
      new(id)
    end
  end

  class BaseWithoutToParam < Struct.new(:id)
    extend Finder

    include Ohm::Slug

    def to_s
      "A very Unique and Interesting String?'"
    end
  end

  test "to_param" do
    obj = BaseWithoutToParam.new(1)

    assert_equal '1-a-very-unique-and-interesting-string', obj.to_param
  end

  test "finding" do
    assert_equal 1, BaseWithoutToParam['1-a-very-unique'].id
  end
end
