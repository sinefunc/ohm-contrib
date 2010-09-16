# encoding: UTF-8

require File.expand_path("./helper", File.dirname(__FILE__))

class User < Ohm::Model
  include Ohm::Typecast

  attribute :is_admin, Boolean
end

test "empty is nil" do
  assert nil == User.new.is_admin

  u = User.create
  u = User[u.id]

  assert nil == User.new.is_admin
end

test "false, 0, '0' is false" do
  [false, 0, '0'].each do |val|
    assert false == User.new(:is_admin => val).is_admin
  end

  [false, 0, '0'].each do |val|
    u = User.create(:is_admin => val)
    u = User[u.id]
    assert false == u.is_admin
  end
end

test "true, 1, '1' is true" do
  [true, 1, '1'].each do |val|
    assert true == User.new(:is_admin => val).is_admin
  end

  [true, 1, '1'].each do |val|
    u = User.create(:is_admin => val)
    u = User[u.id]
    assert true == u.is_admin
  end
end

