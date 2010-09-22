# encoding: UTF-8

require File.expand_path("./helper", File.dirname(__FILE__))

class Post < Ohm::Model
  include Ohm::Typecast

  attribute :created_at, Time

  def now
    Time.now
  end

  def new_time
    Time.new
  end
end

test "still able to access top level Time" do
  assert Post.new.now.to_s == Time.now.to_s
end

test "should be able to use Time.new inside the class" do
  assert Post.new.new_time.to_s == Time.new.to_s
end

test "handles nil case correctly" do
  post = Post.create(:created_at => nil)
  post = Post[post.id]

  assert nil == post.created_at
end

test "handles empty string case correctly" do
  post = Post.create(:created_at => "")
  post = Post[post.id]

  assert "" == post.created_at.to_s
end

test "allows for real time operations" do
  post = Post.create(:created_at => "2010-05-10T00:00Z")
  post = Post[post.id]

  assert post.created_at.respond_to?(:strftime)
  assert "2010-05-10" == post.created_at.strftime('%Y-%m-%d')
end

test "raises when trying to do non-time operations" do
  post = Post.create(:created_at => "FooBar")
  post = Post[post.id]

  assert ! post.created_at.respond_to?(:abs)

  assert_raise NoMethodError do
    post.created_at.abs
  end
end

test "inspecting" do
  post = Post.create(:created_at => Time.utc(2010, 05, 05))
  assert '"2010-05-05 00:00:00 UTC"' == post.created_at.inspect

  post.created_at = 'FooBar'
  assert '"FooBar"' == post.created_at.inspect
end

test "type is Time" do
  post = Post.create(:created_at => Time.utc(2010, 05, 05))
  assert Time == post.created_at.type
end

