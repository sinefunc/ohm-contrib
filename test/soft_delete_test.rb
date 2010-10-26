# encoding: UTF-8

require File.expand_path("./helper", File.dirname(__FILE__))

class Person < Ohm::Model
  include Ohm::SoftDelete

  attribute :name
  index :name

  attribute :age
  index :age
end

test "deleted?" do
  person = Person.create

  assert !person.deleted?

  person.delete

  assert person.deleted?
end

test "all excludes deleted records" do
  person = Person.create(:name => "matz")

  assert Person.all.first == person

  person.delete

  assert Person.all.empty?
end

test "find excludes deleted records" do
  person = Person.create(:name => "matz")

  assert Person.find(:name => "matz").first == person

  person.delete

  assert Person.find(:name => "matz").empty?
  assert Person.all.find(:name => "matz").empty?
end

test "find with many criteria excludes deleted records" do
  person = Person.create(:name => "matz", :age => 38)

  assert Person.find(:name => "matz", :age => 38).first == person

  person.delete

  assert Person.find(:name => "matz", :age => 38).empty?
  assert Person.all.find(:name => "matz", :age => 38).empty?
end

test "exists? returns true for deleted records" do
  person = Person.create(:name => "matz")

  person.delete

  assert Person.exists?(person.id)
end

test "Model[n] can be used to retrieve deleted records" do
  person = Person.create(:name => "matz")

  person.delete

  assert Person[person.id].deleted?
  assert Person[person.id].name == "matz"
end