require "helper"

class TestOhmTimestamping < Test::Unit::TestCase
  setup do
    Ohm.flush
  end

  class Person < Ohm::Model
    include Ohm::Timestamping
  end

  context "a new? record" do
    should "have no created_at" do
      assert_nil Person.new.created_at
    end

    should "have no updated_at" do
      assert_nil Person.new.updated_at
    end
  end

  context "on create" do
    setup do
      @now    = Time.utc(2010, 5, 12)
      Timecop.freeze(@now)
      @person = Person.create
      @person = Person[@person.id]
    end


    should "set the created_at equal to the current time" do
      assert_equal @now.to_s, @person.created_at
    end

    should "also set the updated_at equal to the current time" do
      assert_equal @now.to_s, @person.updated_at
    end
  end

  context "on update" do
    setup do
      Timecop.freeze(Time.utc(2010, 10, 30))

      @person = Person.create
      @old_created_at = @person.created_at.to_s
      @old_updated_at = @person.updated_at.to_s

      @now = Time.utc(2010, 10, 31)
      Timecop.freeze(@now)

      @person.save
      @person = Person[@person.id]
    end

    should "leave created_at unchanged" do
      assert_equal @old_created_at, @person.created_at
    end

    should "set updated_at to the current Time" do
      assert_not_equal @old_updated_at, @person.updated_at
      assert_equal @now.to_s, @person.updated_at
    end
  end
end
