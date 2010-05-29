require "helper"

class TestOhmTypecast < Test::Unit::TestCase
  context "the default case of just an attribute" do
    class Post < Ohm::Model
      include Ohm::Typecast

      attribute :content
    end

    test "handles nil case correctly" do
      post = Post.create(:content => nil)
      post = Post[post.id]

      assert_nil post.content
    end

    test "still responds to string methods properly" do
      post = Post.create(:content => "FooBar")
      post = Post[post.id]

      assert_equal "foobar", post.content.downcase
    end

    test "mutating methods like upcase!" do
      post = Post.create(:content => "FooBar")
      post = Post[post.id]

      post.content.upcase!

      assert_equal "FOOBAR", post.content.to_s
    end

    test "inspecting" do
      post = Post.new(:content => "FooBar")
      assert_equal 'FooBar', post.content
    end
  end

  context "when using a decimal" do
    class Post < Ohm::Model
      include Ohm::Typecast

      attribute :price, Decimal
    end

    test "handles nil case correctly" do
      post = Post.create(:price => nil)
      post = Post[post.id]

      assert_nil post.price
    end

    test "handles empty string case correctly" do
      post = Post.create(:price => "")
      post = Post[post.id]

      assert_equal "", post.price.to_s
    end

    test "allows for real arithmetic" do
      post = Post.create(:price => "0.01")
      post = Post[post.id]

      assert_equal 0.02,   post.price + post.price
      assert_equal 0.0,    post.price - post.price
      assert_equal 0.0001, post.price * post.price
      assert_equal 1.0,    post.price / post.price
    end

    test "is accurate accdg to the decimal spec" do
      post = Post.create(:price => "0.0001")
      post = Post[post.id]

      sum = 0
      1_000.times { sum += post.price }
      assert_equal 0.1, sum
    end

    test "using += with price" do
      post = Post.create(:price => "0.0001")
      post = Post[post.id]

      post.price += 1
      assert_equal 1.0001, post.price.to_f
    end

    test "assigning a raw BigDecimal" do
      post = Post.create(:price => BigDecimal("399.50"))
      post = Post[post.id]

      assert_kind_of String, post.price.to_s
    end

    test "equality matching" do
      post = Post.create(:price => "399.50")
      assert (post.price == "399.50")
    end

    test "inspecting a Decimal" do
      post = Post.new(:price => 399.50)
      assert_equal '399.5', post.price.inspect
    end
  end

  context "when using an integer" do
    class Post < Ohm::Model
      include Ohm::Typecast

      attribute :price, Integer
    end

    test "handles nil case correctly" do
      post = Post.create(:price => nil)
      post = Post[post.id]

      assert_nil post.price
    end

    test "handles empty string case correctly" do
      post = Post.create(:price => "")
      post = Post[post.id]

      assert_equal "", post.price.to_s
    end

    test "allows for real arithmetic" do
      post = Post.create(:price => "3")
      post = Post[post.id]

      assert_equal 6,      post.price + post.price
      assert_equal 0,      post.price - post.price
      assert_equal 9,      post.price * post.price
      assert_equal 1,      post.price / post.price
    end

    test "raises when trying to do arithmetic ops on a non-int" do
      post = Post.create(:price => "FooBar")
      post = Post[post.id]

      assert_raise ArgumentError do
        post.price * post.price
      end
    end

    test "inspecting" do
      post = Post.new(:price => "50000")
      assert_equal '50000', post.price.inspect
    end
  end

  context "when using an float" do
    class Post < Ohm::Model
      include Ohm::Typecast

      attribute :price, Float
    end

    test "handles nil case correctly" do
      post = Post.create(:price => nil)
      post = Post[post.id]

      assert_nil post.price
    end

    test "handles empty string case correctly" do
      post = Post.create(:price => "")
      post = Post[post.id]

      assert_equal "", post.price.to_s
    end

    test "allows for real arithmetic" do
      post = Post.create(:price => "3")
      post = Post[post.id]

      assert_equal 6.0, post.price + post.price
      assert_equal 0.0, post.price - post.price
      assert_equal 9.0, post.price * post.price
      assert_equal 1.0, post.price / post.price
    end

    test "raises when trying to do arithmetic ops on a non-float" do
      post = Post.create(:price => "FooBar")
      post = Post[post.id]

      assert_raise ArgumentError do
        post.price * post.price
      end
    end

    test "inspecting" do
      post = Post.new(:price => "12345.67890")
      assert_equal '12345.6789', post.price.inspect
    end
  end

  context "when using a time" do
    class Post < Ohm::Model
      include Ohm::Typecast

      attribute :created_at, Time

      def now
        Time.now
      end

      def new_time
        Time.new
      end
    end

    test "still able to access top level Time" do
      assert_equal Post.new.now.to_s, Time.now.to_s
    end

    test "should be able to use Time.new inside the class" do
      assert_equal Post.new.new_time.to_s, Time.new.to_s
    end

    test "handles nil case correctly" do
      post = Post.create(:created_at => nil)
      post = Post[post.id]

      assert_nil post.created_at
    end

    test "handles empty string case correctly" do
      post = Post.create(:created_at => "")
      post = Post[post.id]

      assert_equal "", post.created_at.to_s
    end

    test "allows for real time operations" do
      post = Post.create(:created_at => "2010-05-10")
      post = Post[post.id]

      assert_respond_to post.created_at, :strftime
      assert_equal "2010-05-10", post.created_at.strftime('%Y-%m-%d')
    end

    test "raises when trying to do non-time operations" do
      post = Post.create(:created_at => "FooBar")
      post = Post[post.id]

      assert ! post.created_at.respond_to?(:slice)

      assert_raise NoMethodError do
        post.created_at.slice
      end
    end
  end

  context "when using a date" do
    class Post < Ohm::Model
      include Ohm::Typecast

      attribute :created_on, Date

      def today
        ::Date.today
      end

      def date
        Date
      end

      def may_5
        Date.new(2010, 05, 05)
      end

      def base_today
        Date.today
      end
    end

    test "still able to get top level methods" do
      assert_equal Date.today, Post.new.base_today
    end

    test "allows instantiation of dates" do
      assert_equal Date.new(2010, 05, 05), Post.new.may_5
    end

    test "handles nil case correctly" do
      post = Post.create(:created_on => nil)
      post = Post[post.id]

      assert_nil post.created_on
    end

    test "handles empty string case correctly" do
      post = Post.create(:created_on => "")
      post = Post[post.id]

      assert_equal "", post.created_on.to_s
    end

    test "allows for real time operations" do
      post = Post.create(:created_on => "2010-05-10")
      post = Post[post.id]

      assert_respond_to post.created_on, :strftime
      assert_equal "2010-05-10", post.created_on.strftime('%Y-%m-%d')
    end

    test "raises when trying to do date operations on a non-date" do
      post = Post.create(:created_on => "FooBar")
      post = Post[post.id]

      assert_raise ArgumentError do
        post.created_on.strftime("%Y")
      end
    end

    test "still able to access Date" do
      assert_equal Date.today, Post.new.today
    end
  end

  context "when using a Hash" do
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
      assert_equal Hash.new, Ohm::Types::Hash[nil]
      assert_equal Hash.new, Ohm::Types::Hash[""]
      assert_equal Hash.new, Ohm::Types::Hash[{}]

      assert_equal Hash[:a => "b", :c => "d"], 
        Ohm::Types::Hash[{ :a => "b", :c => "d" }]
    end

    test "exporting / dumping" do
      assert_equal "{}", Ohm::Types::Hash[nil].to_s
      assert_equal "{}", Ohm::Types::Hash[""].to_s
      assert_equal "{}", Ohm::Types::Hash[{}].to_s

      assert_equal %q{{"a":"b","c":"d"}},
        Ohm::Types::Hash[{ :a => "b", :c => "d" }].to_s
    end

    test "still able to get top level methods" do
      assert_equal({}, Post.new.hash)
      assert_equal Hash, Post.new.top_level_hash
    end

    test "handles nil case correctly" do
      post = Post.create(:address => nil)
      assert_equal({}, post.address)
      
      post = Post[post.id]
      assert_equal({}, post.address)
    end

    test "handles empty string case correctly" do
      post = Post.create(:address => "")
      assert_equal({}, post.address)
      
      post = Post[post.id]
      assert_equal({}, post.address)
    end

    test "handles populated hashes" do
      address = { "address1" => "#123", "city" => "Singapore", "country" => "SG"}
      post = Post.create(:address => address)
      assert_equal address, post.address
      
      post = Post[post.id]
      assert_equal address, post.address
    end

    test "allows for hash operations" do
      address = { "address1" => "#123", "city" => "Singapore", "country" => "SG"}
      post = Post.create(:address => address)
      
      assert_equal ["address1", "city", "country"], post.address.keys
      assert_equal ["#123", "Singapore", "SG"], post.address.values

      post = Post[post.id]
      assert_equal ["address1", "city", "country"], post.address.keys
      assert_equal ["#123", "Singapore", "SG"], post.address.values
    end

    test "handles mutation" do
      address = { "address1" => "#123", "city" => "Singapore", "country" => "SG"}
      post = Post.create(:address => address)
      
      post.address["address1"] = "#456"
      post.save

      assert_equal ["address1", "city", "country"], post.address.keys
      assert_equal ["#456", "Singapore", "SG"], post.address.values

      post = Post[post.id]
      assert_equal ["address1", "city", "country"], post.address.keys
      assert_equal ["#456", "Singapore", "SG"], post.address.values
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
  end

  context "when using an Array" do
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
      assert_equal [], Ohm::Types::Array[nil]
      assert_equal [], Ohm::Types::Array[""]
      assert_equal [], Ohm::Types::Array[[]]

      assert_equal ['a', 'b', 'c', 'd'],
        Ohm::Types::Array[['a', 'b', 'c', 'd']]
    end

    test "exporting / dumping" do
      assert_equal "[]", Ohm::Types::Array[nil].to_s
      assert_equal "[]", Ohm::Types::Array[""].to_s
      assert_equal "[]", Ohm::Types::Array[[]].to_s

      assert_equal %q{["a","b","c","d"]},
        Ohm::Types::Array[['a', 'b', 'c', 'd']].to_s
    end

    test "still able to get top level methods" do
      assert_equal([], Post.new.array)
      assert_equal Array, Post.new.top_level_array
    end

    test "handles nil case correctly" do
      post = Post.create(:addresses => nil)
      assert_equal([], post.addresses)
      
      post = Post[post.id]
      assert_equal([], post.addresses)
    end

    test "handles empty string case correctly" do
      post = Post.create(:addresses => "")
      assert_equal([], post.addresses)
      
      post = Post[post.id]
      assert_equal([], post.addresses)
    end

    test "handles populated arrays" do
      addresses = [{"city" => "Singapore", "country" => "SG"},
                   {"city" => "Manila", "country" => "PH"}]

      post = Post.create(:addresses => addresses)
      assert_equal addresses, post.addresses
      
      post = Post[post.id]
      assert_equal addresses, post.addresses
    end
    
    class Address < Struct.new(:city, :country)
      def to_json
        [city, country].to_json
      end
    end

    test "handles an arbitrary class as an element of the array" do
      addresses = [Address.new("Singapore", "SG"),
                   Address.new("Philippines", "PH")]
  
      post = Post.create(:addresses => addresses)
      assert_equal [['Singapore', 'SG'], ['Philippines', 'PH']], post.addresses
      
      post = Post[post.id]
      assert_equal [['Singapore', 'SG'], ['Philippines', 'PH']], post.addresses
    end

    test "allows for array operations" do
      addresses = [{"city" => "Singapore", "country" => "SG"},
                   {"city" => "Manila", "country" => "PH"}]


      post = Post.create(:addresses => addresses)
      assert_equal 2, post.addresses.size
      assert_equal addresses + [{"city" => "Hong Kong", "country" => "ZN"}],
        post.addresses.push({"city" => "Hong Kong", "country" => "ZN"})

      post = Post[post.id]
      assert_equal 2, post.addresses.size
      assert_equal addresses + [{"city" => "Hong Kong", "country" => "ZN"}],
        post.addresses.push({"city" => "Hong Kong", "country" => "ZN"})
    end

    test "looping! and other enumerablems" do
      array = [1, 2, 3]
      post = Post.create(:addresses => array)

      total = 0
      post.addresses.each { |e| total += e }
      assert_equal 6, total

      post = Post[post.id]
      total = 0
      post.addresses.each { |e| total += e }
      assert_equal 6, total
    end

    test "handles mutation" do
      post = Post.create(:addresses => [1, 2, 3])
      
      post.addresses.push(4, 5, 6)
      post.save

      assert_equal 6, post.addresses.size
      assert_equal [1, 2, 3, 4, 5, 6], post.addresses

      post = Post[post.id]
      assert_equal 6, post.addresses.size
      assert_equal [1, 2, 3, 4, 5, 6], post.addresses
    end
  

    test "raises when trying to assign a non-array" do
      assert_raise TypeError do
        Post.new(:addresses => {})
      end

      assert_raise TypeError do
        Post.new(:addresses => Address.new)
      end
    end
  end
end
