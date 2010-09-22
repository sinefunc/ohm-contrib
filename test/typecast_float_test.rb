# encoding: UTF-8

require File.expand_path("./helper", File.dirname(__FILE__))

class Post < Ohm::Model
  include Ohm::Typecast

  attribute :price, Float
end

test "handles nil case correctly" do
  post = Post.create(:price => nil)
  post = Post[post.id]

  assert nil == post.price
end

test "handles empty string case correctly" do
  post = Post.create(:price => "")
  post = Post[post.id]

  assert "" == post.price.to_s
end

test "allows for real arithmetic" do
  post = Post.create(:price => "3")
  post = Post[post.id]

  assert 6.0 == post.price + post.price
  assert 0.0 == post.price - post.price
  assert 9.0 == post.price * post.price
  assert 1.0 == post.price / post.price
end

test "raises when trying to do arithmetic ops on a non-float" do

  post = Post.create(:price => "FooBar")
  post = Post[post.id]

  assert_raise ArgumentError do
    post.price * post.price
  end
end

test "inspecting" do
  post = Post.new(:price => "12345.67890")
  assert '"12345.67890"' == post.price.inspect

  post.price = 'FooBar'
  assert '"FooBar"' == post.price.inspect
end

test "type is Float" do
  post = Post.new(:price => 399.50)
  assert Float == post.price.type
end

