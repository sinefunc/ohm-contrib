# encoding: UTF-8

require File.expand_path("./helper", File.dirname(__FILE__))

class Post < Ohm::Model
  include Ohm::Typecast

  attribute :content
end

test "handles nil case correctly" do
  post = Post.create(:content => nil)
  post = Post[post.id]

  assert nil == post.content
end

test "still responds to string methods properly" do
  post = Post.create(:content => "FooBar")
  post = Post[post.id]

  assert "foobar" == post.content.downcase
end

test "mutating methods like upcase!" do
  post = Post.create(:content => "FooBar")
  post = Post[post.id]

  post.content.upcase!

  assert "FOOBAR" == post.content.to_s
end

test "inspecting" do
  post = Post.new(:content => "FooBar")
  assert 'FooBar' == post.content
end

test "type is String" do
  post = Post.new(:content => "FooBar")
  assert String == post.content.type
end

