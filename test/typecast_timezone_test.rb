# encoding: UTF-8

require File.expand_path("./helper", File.dirname(__FILE__))

class Post < Ohm::Model
  include Ohm::Typecast

  attribute :printed_at, Time
end

test "2010-08-07T00:00Z is parsed as 2010-08-07 00:00:00 UTC" do
  post = Post.new(:printed_at => "2010-08-07T00:00Z")
  assert Time.utc(2010, 8, 7).to_s == post.printed_at.utc.to_s

  post.save
  post = Post[post.id]
  assert Time.utc(2010, 8, 7).to_s == post.printed_at.utc.to_s
end

test "2010-08-07 18:29Z is parsed as 2010-08-07 18:29:00 UTC" do
  post = Post.new(:printed_at => "2010-08-07 18:29Z")
  assert Time.utc(2010, 8, 7, 18, 29).to_s == post.printed_at.utc.to_s

  post.save
  post = Post[post.id]
  assert Time.utc(2010, 8, 7, 18, 29).to_s == post.printed_at.utc.to_s
end

test "2010-08-07T18:29:31Z is parsed as 2010-08-07 18:29:31 UTC" do
  post = Post.new(:printed_at => "2010-08-07T18:29:31Z")
  assert Time.utc(2010, 8, 7, 18, 29, 31).to_s == post.printed_at.utc.to_s

  post.save
  post = Post[post.id]
  assert Time.utc(2010, 8, 7, 18, 29, 31).to_s == post.printed_at.utc.to_s
end

