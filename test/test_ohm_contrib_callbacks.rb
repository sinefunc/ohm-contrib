require "helper"

class OhmContribCallbacksTest < Test::Unit::TestCase
  class Post < Ohm::Model
    include Ohm::Callbacks

    attribute :body
    
    before :validate, :do_before_validate
    after  :validate, :do_after_validate

    before :create,   :do_before_create
    after  :create,   :do_after_create

    before :save,     :do_before_save
    after  :save,     :do_after_save

    def validate
      super

      assert_present :body
    end

    def did?(action)
      instance_variable_get("@#{ action }")
    end

  protected
    def do_before_validate() @do_before_validate = true  end
    def do_after_validate()  @do_after_validate = true   end
    def do_before_create()   @do_before_create = true    end
    def do_after_create()    @do_after_create = true     end
    def do_before_save()     @do_before_save = true      end
    def do_after_save()      @do_after_save = true       end
  end

  context "on save when invalid state" do
    setup do
      @post = Post.new
      @post.save
    end
    
    should "still call before / after validate" do
      assert @post.did?(:do_before_validate)      
      assert @post.did?(:do_after_validate)
    end

    should "not call all other callbacks" do
      assert ! @post.did?(:do_before_create)
      assert ! @post.did?(:do_after_create)
      assert ! @post.did?(:do_before_save)
      assert ! @post.did?(:do_after_save)
    end
  end

  context "on save when valid state" do
    setup do
      @post = Post.new(:body => "The Body")
      @post.save
    end
    
    should "call all callbacks" do
      assert @post.did?(:do_before_validate)
      assert @post.did?(:do_after_validate)
      assert @post.did?(:do_before_create)
      assert @post.did?(:do_after_create)
      assert @post.did?(:do_before_save)
      assert @post.did?(:do_after_save)
    end
  end

  context "on save of an existing object" do
    setup do
      @post = Post.create(:body => "The Body")
      @post = Post[@post.id]

      @post.save
    end
    
    should "not call create related callbacks" do
      assert ! @post.did?(:do_before_create)
      assert ! @post.did?(:do_after_create)
    end

    should "call the rest of the callbacks" do
      assert @post.did?(:do_before_validate)
      assert @post.did?(:do_after_validate)
      assert @post.did?(:do_before_save)
      assert @post.did?(:do_after_save)
    end    
  end

  context "on save of an existing invalid object" do
    setup do
      @post = Post.create(:body => "The Body")
      @post = Post[@post.id]

      @post.body = nil
      @post.save
    end

    should "call validation related callbacks" do
      assert @post.did?(:do_before_validate)
      assert @post.did?(:do_after_validate)
    end
   
    should "not call create related callbacks" do
      assert ! @post.did?(:do_before_create)
      assert ! @post.did?(:do_after_create)
    end

    should "also not call save related callbacks" do
      assert ! @post.did?(:do_before_save)
      assert ! @post.did?(:do_after_save)
    end
  end
end
