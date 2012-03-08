# encoding: utf-8

require_relative "helper"

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
  a = Article.create(title: "Foo<br>Bar")

  assert_equal "Foo Bar", a.title
  assert_equal 1, a.comments.size
end

class Post < Ohm::Model
  attribute :title

  include Ohm::Slug

  def to_s
    title
  end
end

test "slugging" do
  post = Post.create(title: "Foo Bar Baz")
  assert_equal "1-foo-bar-baz", post.to_param

  post = Post.create(title: "Décor")
  assert_equal "2-decor", post.to_param
end

class Order < Ohm::Model
  include Ohm::Scope

  attribute :state
  index :state

  attribute :deleted
  index :deleted

  scope do
    def paid
      find(state: "paid")
    end

    def deleted
      find(deleted: 1)
    end
  end
end

test "scope" do
  Order.index :state
  Order.index :deleted

  paid = Order.create(state: "paid", deleted: nil)

  assert Order.all.paid.include?(paid)
  assert_equal 0, Order.all.paid.deleted.size

  paid.update(deleted: 1)
  assert Order.all.paid.deleted.include?(paid)
end

class User < Ohm::Model
  include Ohm::SoftDelete

  attribute :email
  index :email
end

test "soft delete" do
  User.index :email

  user = User.create(email: "a@a.com")
  user.delete

  assert User.all.empty?
  assert User.deleted.include?(user)
  assert User.find(email: "a@a.com").include?(user)

  assert user.deleted?
  assert User[user.id] == user

  user.restore

  assert User.all.include?(user)
  assert User.deleted.empty?

  assert ! user.deleted?
end

class Product < Ohm::Model
  include Ohm::DataTypes

  attribute :name
  attribute :stock, Type::Integer
  attribute :price, Type::Decimal
  attribute :rating, Type::Float
  attribute :bought_at, Type::Time
  attribute :date_released, Type::Date
  attribute :sizes, Type::Hash
  attribute :stores, Type::Array
  attribute :published, Type::Boolean
end

test "datatypes" do
  p = Product.new(stock: "1")

  assert_equal 1, p.stock
  p.save

  p = Product[p.id]
  assert_equal 1, p.stock

  time = Time.now.utc
  p = Product.new(bought_at: time)
  assert p.bought_at.kind_of?(Time)

  p.save

  p = Product[p.id]
  assert p.bought_at.kind_of?(Time)
  assert_equal time, p.bought_at

  p = Product.new(date_released: Date.today)

  assert p.date_released.kind_of?(Date)

  p = Product.new(date_released: "2011-11-22")
  assert p.date_released.kind_of?(Date)

  p.save

  p = Product[p.id]
  assert_equal Date.new(2011, 11, 22), p.date_released

  sizes = { "XS" => 1, "S" => 2, "L" => 3 }

  p = Product.new(sizes: sizes)
  assert p.sizes.kind_of?(Hash)
  p.save

  p = Product[p.id]
  assert_equal sizes, p.sizes

  stores = ["walmart", "marshalls", "jcpenny"]
  p = Product.new(stores: stores)
  assert p.stores.kind_of?(Array)

  p.save

  p = Product[p.id]
  assert_equal stores, p.stores

  p = Product.new(price: 0.001)

  x = 0
  1000.times { x += p.price }
  assert_equal 1, x

  p.save

  p = Product[p.id]
  assert_equal 0.001, p.price

  p = Product.new(rating: 4.5)
  assert p.rating.kind_of?(Float)

  p.save
  p = Product[p.id]
  assert_equal 4.5, p.rating

  p = Product.new(published: 1)
  assert_equal true, p.published

  p.save

  p = Product[p.id]
  assert_equal true, p.published
end
