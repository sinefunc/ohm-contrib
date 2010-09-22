# encoding: UTF-8

require File.expand_path("./helper", File.dirname(__FILE__))

class Post < Ohm::Model
  include Ohm::Typecast

  attribute :created_on, Date

  def today
    ::Date.today
  end

  def date
    Date
  end

  def may_5
    Date.new(2010, 05, 05)
  end

  def base_today
    Date.today
  end
end

test "still able to get top level methods" do
  assert Date.today == Post.new.base_today
end

test "allows instantiation of dates" do
  assert Date.new(2010, 05, 05) == Post.new.may_5
end

test "handles nil case correctly" do
  post = Post.create(:created_on => nil)
  post = Post[post.id]

  assert nil == post.created_on
end

test "handles empty string case correctly" do
  post = Post.create(:created_on => "")
  post = Post[post.id]

  assert "" == post.created_on.to_s
end

test "allows for real time operations" do
  post = Post.create(:created_on => "2010-05-10")
  post = Post[post.id]

  assert post.created_on.respond_to?(:strftime)
  assert "2010-05-10" == post.created_on.strftime('%Y-%m-%d')
end

test "raises when trying to do date operations on a non-date" do
  post = Post.create(:created_on => "FooBar")
  post = Post[post.id]

  assert_raise ArgumentError do
    post.created_on.strftime("%Y")
  end
end

test "still able to access Date" do
  assert Date.today == Post.new.today
end

test "inspecting" do
  post = Post.create(:created_on => Date.new(2010, 5, 5))
  assert '"2010-05-05"' == post.created_on.inspect

  post.created_on = 'FooBar'
  assert '"FooBar"' == post.created_on.inspect
end

test "type is Date" do
  post = Post.create(:created_on => Date.new(2010, 5, 5))
  assert Date == post.created_on.type
end

