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
      assert_equal 50000, post.price.inspect
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
      assert_equal 12345.67890, post.price.inspect
    end
  end

  context "when using a time" do
    class Post < Ohm::Model
      include Ohm::Typecast

      attribute :created_at, Time

      def now
        Time.now
      end

      def time
        Time
      end
    end
    
    test "still able to access top level Time" do
      post = Post.new
      assert_equal post.now.to_s, Time.now.to_s
    end

    test "responds to all ::Time class methods" do
      post = Post.new
      methods = [
        :_load, :apply_offset, :at, :gm, :httpdate, :json_create, :local,
        :make_time, :mktime, :month_days, :new, :now, :parse, :rfc2822, 
        :strptime, :utc, :w3cdtf, :xmlschema, :yaml_new, :zone_offset, 
        :zone_utc?
      ]
      
      methods.each do |m|
        assert_respond_to post.time, m
      end
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

      def base_today
        Date.today
      end
    end
    
    test "still able to get top level methods" do
      assert_equal Date.today, Post.new.base_today
    end

    test "responds to all the class methods" do
      post = Post.new

      methods = [
        :_parse, :_strptime, :civil, :commercial, :gregorian_leap?, :jd, 
        :json_create, :julian_leap?, :now, :nth_kday, :ordinal, :parse, :s3e, 
        :strptime, :today, :valid_civil?, :valid_commercial?, :valid_jd?, 
        :valid_ordinal?, :weeknum
      ]
      methods.each do |m|
        assert_respond_to post.date, m
      end
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
end
