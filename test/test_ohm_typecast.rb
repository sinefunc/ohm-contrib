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
  end

  context "when using a time" do
    class Post < Ohm::Model
      include Ohm::Typecast
      
      attribute :created_at, Time
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
