# encoding: UTF-8

require File.expand_path("./helper", File.dirname(__FILE__))

class Post < Ohm::Model
  include Ohm::Typecast

  attribute :addresses, Array

  def array
    Array.new
  end

  def top_level_array
    Array
  end
end

test "importing" do
  assert [] == Ohm::Types::Array[nil]
  assert [] == Ohm::Types::Array[""]
  assert [] == Ohm::Types::Array[[]]

  assert ['a', 'b', 'c', 'd'] == Ohm::Types::Array[['a', 'b', 'c', 'd']]
end

test "exporting / dumping" do
  assert "[]" == Ohm::Types::Array[nil].to_s
  assert "[]" == Ohm::Types::Array[""].to_s
  assert "[]" == Ohm::Types::Array[[]].to_s

  assert %q{["a","b","c","d"]} == Ohm::Types::Array[['a', 'b', 'c', 'd']].to_s
end

test "still able to get top level methods" do
  assert [] == Post.new.array
  assert Array == Post.new.top_level_array
end

test "handles nil case correctly" do
  post = Post.create(:addresses => nil)
  assert [] == post.addresses

  post = Post[post.id]
  assert [] == post.addresses
end

test "handles empty string case correctly" do
  post = Post.create(:addresses => "")
  assert [] == post.addresses

  post = Post[post.id]
  assert [] == post.addresses
end

test "handles populated arrays" do
  addresses = [{"city" => "Singapore", "country" => "SG"},
               {"city" => "Manila", "country" => "PH"}]

  post = Post.create(:addresses => addresses)
  assert addresses == post.addresses

  post = Post[post.id]
  assert addresses == post.addresses
end

class AddressArr < Class.new(Struct.new(:city, :country))
  def to_json(*args)
    [city, country].to_json(*args)
  end
end

test "handles an arbitrary class as an element of the array" do
  addresses = [AddressArr.new("Singapore", "SG"),
               AddressArr.new("Philippines", "PH")]

  post = Post.create(:addresses => addresses)
  assert [['Singapore', 'SG'], ['Philippines', 'PH']] == post.addresses

  post = Post[post.id]
  assert [['Singapore', 'SG'], ['Philippines', 'PH']] == post.addresses
end

test "allows for array operations" do
  addresses = [{"city" => "Singapore", "country" => "SG"},
               {"city" => "Manila", "country" => "PH"}]


  post = Post.create(:addresses => addresses)
  assert 2 == post.addresses.size

  expected = addresses + [{"city" => "Hong Kong", "country" => "ZN"}]
  actual   = post.addresses.push({"city" => "Hong Kong", "country" => "ZN"})

  assert expected == actual

  post = Post[post.id]
  assert 2 == post.addresses.size

  expected = addresses + [{"city" => "Hong Kong", "country" => "ZN"}]
  actual   = post.addresses.push({ "city" => "Hong Kong", "country" => "ZN" })

  assert expected == actual
end

test "looping! and other enumerablems" do
  array = [1, 2, 3]
  post = Post.create(:addresses => array)

  total = 0
  post.addresses.each { |e| total += e }
  assert 6 == total

  post = Post[post.id]
  total = 0
  post.addresses.each { |e| total += e }
  assert 6 == total
end

test "handles mutation" do
  post = Post.create(:addresses => [1, 2, 3])

  post.addresses.push(4, 5, 6)
  post.save

  assert [1, 2, 3, 4, 5, 6] == post.addresses

  post = Post[post.id]
  assert [1, 2, 3, 4, 5, 6] == post.addresses
end

test "raises when trying to assign a non-array" do
  assert_raise TypeError do
    Post.new(:addresses => {})
  end

  assert_raise TypeError do
    Post.new(:addresses => AddressArr.new)
  end
end

test "inspecting" do
  post = Post.create(:addresses => [{ "address1" => "#456",
                                      "city" => "Singapore",
                                      "country" => "SG" }])

  expected = %q{[{"address1":"#456","city":"Singapore","country":"SG"}]}

  assert expected == post.addresses.inspect

  post.addresses = 'FooBar'
  assert %{"\\\"FooBar\\\""} == post.addresses.inspect
end

test "type is array" do
  post = Post.create(:addresses => ["address1"])

  assert post.addresses.type == Array
end

