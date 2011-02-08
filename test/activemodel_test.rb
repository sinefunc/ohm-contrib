# encoding: UTF-8

require File.expand_path("./helper", File.dirname(__FILE__))

require "test/unit"
require "active_model"

class ActiveModelTest < Test::Unit::TestCase
  include ActiveModel::Lint::Tests

  class Post < Ohm::Model
    include Ohm::ActiveModelExtension

    attribute :body
    list :related, Post

    def validate
      assert_present :body
    end
  end

  def setup
    @model = Post.new
  end
end


