require "helper"

class TestOhmToHash < Test::Unit::TestCase
  setup do
    Ohm.flush
  end

  context "a Person with name: matz, age: nil, skills: 10" do
    class Person < Ohm::Model
      include Ohm::ToHash

      attribute :name
      attribute :age
      attribute :skills
    end

    setup do
      @person = Person.create(:name => 'matz', :skills => 10)
      @person = Person[@person.id]
    end

    should "have a to_hash of { id: 1, name: 'matz', age: nil, skills: 10 }" do
      assert_equal(
        { :id => '1', :name => "matz", :age => nil, :skills => '10' },
        @person.to_hash
      )
    end
  end

  context "when a Post has a votes counter" do
    class Post < Ohm::Model
      include Ohm::ToHash

      counter :votes
    end

    setup do
      @post = Post.create
      @post.incr :votes
      @post.incr :votes
      @post.incr :votes
    end

    should "include the votes in the hash" do
      assert_equal({ :id => '1', :votes => 3 }, @post.to_hash)
    end
  end

  context "when a comment has a reference to a person" do
    self::Person = Class.new(Ohm::Model)

    class Comment < Ohm::Model
      include Ohm::ToHash

      reference :person, Person
    end

    setup do
      @person = Person.create
      @comment = Comment.create(:person => @person)
    end

    should "have the person_id in the hash" do
      assert_equal({ :id => '1', :person_id => '1' }, @comment.to_hash)
    end
  end
end
