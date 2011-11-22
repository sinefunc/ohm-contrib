# encoding: UTF-8

require_relative "helper"

class Article < Ohm::Model
  plugin :slug
  attribute :title

  def to_s
    title
  end
end

test "to_param" do
  article = Article.create(title: "A very Unique and Interesting String?'")

  assert '1-a-very-unique-and-interesting-string' == article.to_param
end

test "finding" do
  article = Article.create(title: "A very Unique and Interesting String?'")

  assert 1 == Article["1-a-very-unique-and-interesting-string"].id
end