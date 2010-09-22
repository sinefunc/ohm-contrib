# encoding: UTF-8

require File.expand_path("./helper", File.dirname(__FILE__))

class Post < Ohm::Model
  include Ohm::Typecast

  attribute :price, Decimal
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
  post = Post.create(:price => "0.01")
  post = Post[post.id]

  assert 0.02   == post.price + post.price
  assert 0.0    == post.price - post.price
  assert 0.0001 == post.price * post.price
  assert 1.0    == post.price / post.price
end

test "is accurate accdg to the decimal spec" do
  post = Post.create(:price => "0.0001")
  post = Post[post.id]

  sum = 0
  1_000.times { sum += post.price }
  assert 0.1 == sum
end

test "using += with price" do
  post = Post.create(:price => "0.0001")
  post = Post[post.id]

  post.price += 1
  assert 1.0001 == post.price.to_f
end

test "assigning a raw BigDecimal" do
  post = Post.create(:price => BigDecimal("399.50"))
  post = Post[post.id]

  assert post.price.to_s.kind_of?(String)
end

test "equality and comparable matching" do
  post = Post.create(:price => "399.50")
  assert (post.price == "399.50")
  assert (post.price < 399.51)
  assert (post.price > 399.49)
  assert (post.price <= 399.50)
  assert (post.price <= 399.51)
  assert (post.price >= 399.50)
  assert (post.price >= 399.49)
end

test "inspecting a Decimal" do
  post = Post.new(:price => 399.50)
  assert '"399.5"' == post.price.inspect

  post.price = 'FooBar'
  assert '"FooBar"' == post.price.inspect
end

test "type is BigDecimal" do
  post = Post.new(:price => 399.50)
  assert BigDecimal == post.price.type
end

