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
      
      assert_equal @time, product.start_of_sale
    end

    test "the retrieved value is a Time object" do
      @time = Time.now.utc
      product = Product.create(:start_of_sale => @time)
      product = Product[product.id]
       
      assert_kind_of Time, product.start_of_sale
    end

    test "an invalid string" do
      product = Product.create(:start_of_sale => "invalid time")
      product = Product[product.id]

      assert_equal "invalid time", product.start_of_sale
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

    test "assigning a string which is not a valid date before persisting" do
      product = Product.create(:date_bought => "Bla Bla")
      
      assert_equal "Bla Bla", product.date_bought
    end
  
    test "when nil" do
      assert_nil Product.new.date_bought
    end

    test "empty string" do
      assert_equal "", Product.new(:date_bought => "").date_bought
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
end
