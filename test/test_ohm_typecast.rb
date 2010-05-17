require "helper"

class TestOhmTypecast < Test::Unit::TestCase
  context "decimal typecasting" do
    class Product < Ohm::Model
      include Ohm::Typecast

      attribute :price, Decimal
    end

    should "properly preserve the right precision" do
      product = Product.create(:price => 0.0001)
      product = Product[product.id]
      sum = 0
      1_000.times { sum += product.price }

      assert_equal 0.1, sum
    end

    context "given a non-decimal value FooBar" do
      should "preseve the value FooBar" do
        product = Product.new(:price => "FooBar")
        assert_equal "FooBar", product.price
      end

      should "raise a MissingValidation error during validation" do
        product = Product.new(:price => "FooBar")

        assert_raise Ohm::Typecast::MissingValidation do
          product.valid?
        end
      end
    end

    context "given a non-decimal value FooBar but with assert_type_decimal" do
      class Post < Ohm::Model
        include Ohm::Typecast

        attribute :price, Decimal

        def validate
          super

          assert_type_decimal :price
        end
      end

      should "be invalid and have an error on the field" do
        post = Post.new(:price => "FooBar")

        assert ! post.valid?
        assert_equal [[:price, :not_decimal]], post.errors
      end
    end
  end

  context "time typecasting" do
    class Product < Ohm::Model
      include Ohm::Typecast

      attribute :start_of_sale, Time
    end

    test "read / write" do
      @time = Time.now.utc
      product = Product.create(:start_of_sale => @time)
      product = Product[product.id]

      assert_equal @time.to_s, product.start_of_sale.to_s
    end

    test "the retrieved value is a Time object" do
      @time = Time.now.utc
      product = Product.create(:start_of_sale => @time)
      product = Product[product.id]

      assert_kind_of Time, product.start_of_sale
    end

    test "an invalid string" do
      assert_raise Ohm::Typecast::MissingValidation do
        product = Product.create(:start_of_sale => "invalid time")
      end
    end

    test "when nil" do
      product = Product.new(:start_of_sale => nil)
      assert_nil product.start_of_sale
    end

    test "when empty string" do
      product = Product.new(:start_of_sale => "")
      assert_equal "", product.start_of_sale
    end
  end

  context "time typecasting with assert_type_time" do
    class Post < Ohm::Model
      include Ohm::Typecast

      attribute :start_of_sale, Time

      def validate
        super

        assert_type_time :start_of_sale
      end
    end

    should "be valid given invalid time value" do
      post = Post.new(:start_of_sale => "FooBar")
      assert ! post.valid?
      assert_equal [[:start_of_sale, :not_time]], post.errors
    end
  end

  context "date typecasting" do
    class Product < Ohm::Model
      include Ohm::Typecast

      attribute :date_bought, Date
    end

    test "read / write" do
      @date = Date.today
      product = Product.create(:date_bought => @date)
      product = Product[product.id]

      assert_equal @date, product.date_bought
    end

    test "the retrieved value is a Date object" do
      @date = Date.today
      product = Product.create(:date_bought => @date)
      product = Product[product.id]

      assert_kind_of Date, product.date_bought
    end

    test "assigning a string which is not a valid date" do
      assert_raise Ohm::Typecast::MissingValidation do
        product = Product.create(:date_bought => "Bla Bla")
      end
    end

    test "when nil" do
      assert_nil Product.new.date_bought
    end

    test "empty string" do
      assert_equal "", Product.new(:date_bought => "").date_bought
    end
  end

  context "date typecasting with assert_type_date" do
    class Post < Ohm::Model
      include Ohm::Typecast

      attribute :created, Date

      def validate
        assert_type_date :created
      end
    end

    should "have an invalid created field on save" do
      post = Post.new(:created => "FooBar")
      assert ! post.valid?
      assert_equal [[:created, :not_date]], post.errors
      assert_equal "FooBar", post.created
    end
  end

  context "integer typecasting" do
    class Product < Ohm::Model
      include Ohm::Typecast

      attribute :stock_count, Integer
    end

    test "when nil" do
      assert_nil Product.new(:stock_count => nil).stock_count
    end

    test "when empty string" do
      assert_equal "", Product.new(:stock_count => "").stock_count
    end

    test "when unparseable" do
      assert_equal "FooBar", Product.new(:stock_count => "FooBar").stock_count
    end

    test "when a float" do
      assert_equal '1.0', Product.new(:stock_count => "1.0").stock_count
    end

    test "when a real int" do
      assert_equal 1, Product.new(:stock_count => '1').stock_count
    end
  end

  context "integer typecasting with assert_type_integer validation" do
    class Post < Ohm::Model
      include Ohm::Typecast

      attribute :counter, Integer

      def validate
        assert_type_integer :counter
      end
    end

    should "have an error on counter given a non-integer value" do
      post = Post.new(:counter => "FooBar")
      assert ! post.valid?
      assert_equal [[:counter, :not_integer]], post.errors
      assert_equal "FooBar", post.counter
    end
  end

  context "float typecasting" do
    class Product < Ohm::Model
      include Ohm::Typecast

      attribute :vat, Float
    end

    test "when nil" do
      assert_nil Product.new(:vat => nil).vat
    end

    test "when empty string" do
      assert_equal "", Product.new(:vat => "").vat
    end

    test "when unparseable" do
      assert_equal "FooBar", Product.new(:vat => "FooBar").vat
    end

    test "when a float" do
      assert_equal 1.0, Product.new(:vat => "1.0").vat
    end

    test "when an int" do
      assert_equal 1.0, Product.new(:vat => '1').vat
    end

    test "when a .12 value" do
      assert_equal 0.12, Product.new(:vat => ".12").vat
    end
  end

  context "float typecasting with assert_type_float validation" do
    class Post < Ohm::Model
      include Ohm::Typecast

      attribute :quotient, Float

      def validate
        assert_type_float :quotient
      end
    end

    should "have an error on quotient given a non-float value" do
      post = Post.new(:quotient => "FooBar")
      assert ! post.valid?
      assert_equal [[:quotient, :not_float]], post.errors
      assert_equal "FooBar", post.quotient
    end
  end


  context "trying to validate numericality of a decimal" do
    class Item < Ohm::Model
      include Ohm::Typecast

      attribute :price, Decimal

      def validate
        assert_numeric :price
      end
    end

    setup do
      @item = Item.new(:price => "FooBar")
    end

    test "invalidation of price" do
      assert ! @item.valid?
      assert_equal [[:price, :not_numeric]], @item.errors
    end
  end

  context "specifying a custom DataType without a #dump method" do
    class ::FooBar < Struct.new(:value)
      def self.[](str)
        new(str)
      end
    end
    
    class Item < Ohm::Model
      include Ohm::Typecast

      attribute :foo, FooBar
    end

    should "use it as expected" do
      item = Item.new(:foo => "bar")
      assert_equal FooBar.new("bar"), item.foo
    end
  end

  context "specifying a customer DataType but with a #dump method" do
    class ::CSV < Array
      def self.dump(arr)
        arr.join(',')
      end

      def self.[](str)
        new(str.split(','))
      end

      def to_s
        join(',')
      end
    end

    class Item < Ohm::Model
      include Ohm::Typecast

      attribute :csv, CSV
    end


    should "dump the appropriate value" do
      item = Item.new(:csv => [ 'first', 'second', 'third'])
      
      assert_equal 'first,second,third', item.send(:read_local, :csv)
    end

    should "be able to retrieve it back properly" do
      item = Item.create(:csv => [ 'first', 'second', 'third'])
      item = Item[item.id]

      assert_equal ['first', 'second', 'third'], item.csv
    end

    should "also be able to read/write with raw CSV" do
      item = Item.create(:csv => CSV.new(['first', 'second', 'third']))
      item = Item[item.id]

      assert_equal ['first', 'second', 'third'], item.csv
    end
  end

  context "defaut Strings" do
    class Post < Ohm::Model
      include Ohm::Typecast
      
      attribute :field1
      attribute :field2
      attribute :field3
    end

    should "not throw a validation missing exception during save" do
      assert_nothing_raised Ohm::Typecast::MissingValidation do
        Post.create :field1 => "field1", :field2 => "field2", :field3 => "fld3"
      end
    end
  end
end
