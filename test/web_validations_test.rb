# encoding: UTF-8

require File.expand_path("./helper", File.dirname(__FILE__))

class BlogPost < Ohm::Model
  include Ohm::WebValidations

  attribute :slug

  index :slug

  def validate
    assert_slug :slug
  end
end

class Comment < Ohm::Model
  include Ohm::WebValidations

  attribute :ip_address
  attribute :homepage
  attribute :email

  def validate
    assert_ipaddr :ip_address
    assert_url   :homepage
    assert_email :email
  end
end

test "invalid slug scenario" do
  p = BlogPost.new(:slug => "This is a title, not a SLUG")
  assert ! p.valid?
  assert [[:slug, :not_slug]] == p.errors
end

test "valid slug scenario" do
  p = BlogPost.new(:slug => "this-is-a-valid-slug")
  assert p.valid?
end

test "slug uniqueness validation" do
  p1 = BlogPost.create(:slug => "this-is-a-valid-slug")
  p2 = BlogPost.create(:slug => "this-is-a-valid-slug")

  assert ! p2.valid?
  assert [[:slug, :not_unique]] == p2.errors
end

test "ip address validation" do
  c = Comment.new(:ip_address => "400.500.600.700")
  assert ! c.valid?
  assert c.errors.include?([:ip_address, :not_ipaddr])
end

test "email address validation" do
  c = Comment.new(:email => "something.com")
  assert ! c.valid?
  assert c.errors.include?([:email, :not_email])

  c = Comment.new(:email => "john@doe.com")
  c.valid?
  assert ! c.errors.include?([:email, :not_email])
end

test "url validaiton" do
  c = Comment.new(:homepage => "somehing")
  assert ! c.valid?
  assert c.errors.include?([:homepage, :not_url])

  c = Comment.new(:homepage => "irc://irc.freenode.net/something")
  assert ! c.valid?
  assert c.errors.include?([:homepage, :not_url])

  c = Comment.new(:homepage => "http://test.com")
  c.valid?
  assert ! c.errors.include?([:homepage, :not_url])
end

