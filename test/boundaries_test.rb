# encoding: UTF-8

require File.expand_path("./helper", File.dirname(__FILE__))

class Person < Ohm::Model
  include Ohm::Boundaries

  attribute :name
  index :name
end

test "first / last are nil when no records" do
  assert nil == Person.first
  assert nil == Person.last
end

test "first / last returns the only record when just 1 record" do
  matz = Person.create(:name => "matz")

  assert matz == Person.first
  assert matz == Person.last
end

test "has chronological order by default" do
  matz  = Person.create(:name => "matz")
  linus = Person.create(:name => "linus")

  assert matz == Person.first
  assert linus == Person.last
end

test "respects filters passed in" do
  matz  = Person.create(:name => "matz")
  linus = Person.create(:name => "linus")

  assert matz == Person.first(:name => "matz")
  assert matz == Person.last(:name => "matz")

  assert linus == Person.first(:name => "linus")
  assert linus == Person.last(:name => "linus")

  assert nil == Person.first(:name => "quentin")
  assert nil == Person.last(:name => "quentin")
end

