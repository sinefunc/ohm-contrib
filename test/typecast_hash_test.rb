# encoding: UTF-8

require File.expand_path("./helper", File.dirname(__FILE__))

class Post < Ohm::Model
  include Ohm::Typecast

  attribute :address, Hash

  def hash
    Hash.new
  end

  def top_level_hash
    Hash
  end
end

test "importing" do
  assert Hash.new == Ohm::Types::Hash[nil]
  assert Hash.new == Ohm::Types::Hash[""]
  assert Hash.new == Ohm::Types::Hash[{}]

  expected = Hash[:a => "b", :c => "d"]
  assert expected == Ohm::Types::Hash[{ :a => "b", :c => "d" }]
end

test "exporting / dumping" do
  assert "{}" == Ohm::Types::Hash[nil].to_s
  assert "{}" == Ohm::Types::Hash[""].to_s
  assert "{}" == Ohm::Types::Hash[{}].to_s

  expected = %q{{"a":"b","c":"d"}}
  assert expected == Ohm::Types::Hash[{ :a => "b", :c => "d" }].to_s
end

test "still able to get top level methods" do
  assert Post.new.hash == {}
  assert Hash == Post.new.top_level_hash
end

test "handles nil case correctly" do
  post = Post.create(:address => nil)
  assert post.address == {}

  post = Post[post.id]
  assert post.address == {}
end

test "handles empty string case correctly" do
  post = Post.create(:address => "")
  assert post.address == {}

  post = Post[post.id]
  assert post.address == {}
end

test "handles populated hashes" do
  address = { "address1" => "#123", "city" => "Singapore", "country" => "SG"}
  post = Post.create(:address => address)
  assert address == post.address

  post = Post[post.id]
  assert address == post.address
end

test "allows for hash operations" do
  address = { "address1" => "#123", "city" => "Singapore", "country" => "SG"}
  post = Post.create(:address => address)

  assert ["address1", "city", "country"] == post.address.keys
  assert ["#123", "Singapore", "SG"] == post.address.values

  post = Post[post.id]
  assert ["address1", "city", "country"] == post.address.keys
  assert ["#123", "Singapore", "SG"] == post.address.values
end

test "handles mutation" do
  address = { "address1" => "#123", "city" => "Singapore", "country" => "SG"}
  post = Post.create(:address => address)

  post.address["address1"] = "#456"
  post.save

  assert ["address1", "city", "country"] == post.address.keys
  assert ["#456", "Singapore", "SG"] == post.address.values

  post = Post[post.id]
  assert ["address1", "city", "country"] == post.address.keys
  assert ["#456", "Singapore", "SG"] == post.address.values
end

Address = Class.new(Struct.new(:city, :country))

test "raises when trying to assign a non-hash" do
  assert_raise TypeError do
    Post.new(:address => [])
  end

  assert_raise TypeError do
    Post.new(:address => Address.new)
  end
end

test "inspecting" do
  post = Post.create(:address => { "address1" => "#456",
                                   "city" => "Singapore",
                                   "country" => "SG" })

  expected = %q{{"address1":"#456","city":"Singapore","country":"SG"}}
  assert expected == post.address.inspect

  post.address = 'FooBar'
  assert %{"\\\"FooBar\\\""} == post.address.inspect
end

test "type is Hash" do
  post = Post.new(:address => { "address1" => "#456" })
  assert Hash == post.address.type
end

