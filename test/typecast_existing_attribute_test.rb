# encoding: UTF-8

require File.expand_path("./helper", File.dirname(__FILE__))

class Post < Ohm::Model
  include Ohm::Timestamping
  include Ohm::Typecast

  typecast :created_at, Time
  typecast :updated_at, Time
end

test "created_at and updated_at are typecasted" do
  post = Post.create

  assert post.created_at.respond_to?(:strftime)
  assert post.updated_at.respond_to?(:strftime)

  assert NOW.strftime("%Y-%m-%d") == post.created_at.strftime("%Y-%m-%d")
  assert NOW.strftime("%Y-%m-%d") == post.updated_at.strftime("%Y-%m-%d")
end

