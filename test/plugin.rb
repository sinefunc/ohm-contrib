# encoding: utf-8

require File.expand_path("../helper", __FILE__)
require 'set'

class Comment < Ohm::Model
  include Ohm::Timestamps
end

test "timestamps are added during creation" do
  e = Comment.new
  e.save

  assert e.created_at
  assert e.updated_at
end

class Server < Ohm::Model
  include Ohm::Locking
end

test "mutex method is added at instance and class level" do
  assert Server.new.respond_to?(:mutex)
end

class Article < Ohm::Model
  include Ohm::Callbacks

  attribute :title
  set :comments, Comment

private
  def before_save
    self.title = title.gsub("<br>", " ")
  end

  def after_save
    comments.key.sadd(Comment.create.id)
  end
end

test "class-level, instance level callbacks" do
  a = Article.create(:title => "Foo<br>Bar")

  assert_equal "Foo Bar", a.title
  assert_equal 1, a.comments.size
end

# slugging
scope do
  class Post < Ohm::Model
    attribute :title

    include Ohm::Slug

    def to_s
      title
    end
  end

  test "slugging" do
    post = Post.create(:title => "Foo Bar Baz 1.0")
    assert_equal "1-foo-bar-baz-1-0", post.to_param

    post = Post.create(:title => "Décor")
    assert_equal "2-decor", post.to_param
  end
end

# Ohm::Scope
scope do
  class Order < Ohm::Model
    include Ohm::Scope

    attribute :state
    index :state

    attribute :deleted
    index :deleted

    scope do
      def paid
        find(:state => "paid")
      end

      def deleted
        find(:deleted => 1)
      end
    end
  end

  test "scoping" do
    paid = Order.create(:state => "paid", :deleted => nil)

    assert Order.all.paid.include?(paid)
    assert_equal 0, Order.all.paid.deleted.size

    paid.update(:deleted => 1)
    assert Order.all.paid.deleted.include?(paid)
  end
end

# soft delete
scope do
  class User < Ohm::Model
    include Ohm::SoftDelete

    attribute :email
    index :email
  end

  setup do
    user = User.create(:email => "a@a.com")
    user.delete

    user
  end

  test "removes from User.all" do |user|
    assert User.all.empty?
  end

  test "adds to User.deleted" do |user|
    assert User.deleted.include?(user)
  end

  test "doesn't remove from indices" do |user|
    assert User.find(:email => "a@a.com").include?(user)
  end

  test "makes it deleted?" do |user|
    assert user.deleted?
  end

  test "is still retrievable" do |user|
    assert_equal user, User[user.id]
  end

  test "restore" do |user|
    user.restore

    assert User.all.include?(user)
    assert User.deleted.empty?

    assert ! user.deleted?
  end
end
