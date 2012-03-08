# encoding: UTF-8

require File.expand_path("./helper", File.dirname(__FILE__))

class Person < Ohm::Model
  include Ohm::Timestamps
end

test "a new? record" do
  assert nil == Person.new.created_at
  assert nil == Person.new.updated_at
end

test "on create" do
  person = Person.create
  person = Person[person.id]

  assert NOW == person.created_at
  assert NOW == person.updated_at
end

test "on update" do
  person = Person.create

  override(Time, :now => Time.utc(2010, 5, 13))
  person.save
  person = Person[person.id]

  assert NOW == person.created_at
  assert Time.utc(2010, 5, 13) == person.updated_at
end
