# encoding: UTF-8

require File.expand_path("./helper", File.dirname(__FILE__))

class Post < Ohm::Model
  include Ohm::Typecast

  attribute :price, Integer
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

test "allows respond_to on an invalid integer" do
  post = Post.new(:price => "FooBar")

  assert_nothing_raised ArgumentError do
    post.price.respond_to?(:**)
  end

  assert ! post.price.respond_to?(:**)
end

test "falls back to String#respond_to? when invalid" do
  post = Post.new(:price => "FooBar")
  assert post.price.respond_to?(:capitalize)
end

test "allows for real arithmetic" do
  post = Post.create(:price => "3")
  post = Post[post.id]

  assert 6 == post.price + post.price
  assert 0 == post.price - post.price
  assert 9 == post.price * post.price
  assert 1 == post.price / post.price
end

test "raises when trying to do arithmetic ops on a non-int" do
  post = Post.create(:price => "FooBar")
  post = Post[post.id]

  assert_raise ArgumentError do
    post.price * post.price
  end
end

test "inspecting" do
  post = Post.new(:price => "50000")
  assert '"50000"' == post.price.inspect

  post.price = 'FooBar'
  assert '"FooBar"' == post.price.inspect
end

test "type is Fixnum" do
  post = Post.new(:price => 399)
  assert Fixnum == post.price.type
end

