require "helper"

class OhmContribCallbacksTest < Test::Unit::TestCase
  describe "instance level validation callbacks" do
    class InstanceTypePost < Ohm::Model
      include Ohm::Callbacks

      attribute :body

      def validate
        super

        assert_present :body
      end

      def did?(action)
        instance_variable_get("@#{ action }")
      end

      def count(action)
        instance_variable_get("@#{ action }")
      end

    protected
      def before_validate() incr(:do_before_validate) end
      def after_validate()  incr(:do_after_validate)  end
      def before_create()   incr(:do_before_create)   end
      def after_create()    incr(:do_after_create)    end
      def before_save()     incr(:do_before_save)     end
      def after_save()      incr(:do_after_save)      end
      def before_delete()   incr(:do_before_delete)   end
      def after_delete()    incr(:do_after_delete)    end


      def incr(action)
        val = instance_variable_get("@#{ action }")
        val ||= 0
        val += 1

        instance_variable_set("@#{ action }", val)
      end
    end

    context "on save when invalid state" do
      setup do
        @post = InstanceTypePost.new
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
        @post = InstanceTypePost.new(:body => "The Body")
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

      should "call create / save callbacks only once" do
        assert_equal 1, @post.count(:do_before_create)
        assert_equal 1, @post.count(:do_after_create)
        assert_equal 1, @post.count(:do_before_save)
        assert_equal 1, @post.count(:do_after_create)
      end
    end

    context "on create when valid state" do
      setup do
        @post = InstanceTypePost.create(:body => "The Body")
      end

      should "call all callbacks" do
        assert @post.did?(:do_before_validate)
        assert @post.did?(:do_after_validate)
        assert @post.did?(:do_before_create)
        assert @post.did?(:do_after_create)
        assert @post.did?(:do_before_save)
        assert @post.did?(:do_after_save)
      end

      should "call create / save callbacks only once" do
        assert_equal 1, @post.count(:do_before_create)
        assert_equal 1, @post.count(:do_after_create)
        assert_equal 1, @post.count(:do_before_save)
        assert_equal 1, @post.count(:do_after_create)
      end
    end


    context "on save of an existing object" do
      setup do
        @post = InstanceTypePost.create(:body => "The Body")
        @post = InstanceTypePost[@post.id]

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

      should "call save callbacks only once" do
        assert_equal 1, @post.count(:do_before_save)
        assert_equal 1, @post.count(:do_after_save)
      end
    end

    context "on save of an existing invalid object" do
      setup do
        @post = InstanceTypePost.create(:body => "The Body")
        @post = InstanceTypePost[@post.id]

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

    context "on delete" do
      setup do
        @post = InstanceTypePost.create(:body => "The Body")
        @post = InstanceTypePost[@post.id]
        @post.delete
      end


      should "call delete related callbacks once" do
        assert_equal 1, @post.count(:do_before_delete)
        assert_equal 1, @post.count(:do_after_delete)
      end

      should "not call all other callbacks" do
        assert ! @post.did?(:do_before_validate)
        assert ! @post.did?(:do_after_validate)
        assert ! @post.did?(:do_before_create)
        assert ! @post.did?(:do_after_create)
        assert ! @post.did?(:do_before_save)
        assert ! @post.did?(:do_after_save)
      end
    end
  end

  describe "macro level validation callbacks" do
    class Post < Ohm::Model
      include Ohm::Callbacks

      attribute :body

      before :validate, :do_before_validate
      after  :validate, :do_after_validate

      before :create,   :do_before_create
      after  :create,   :do_after_create

      before :save,     :do_before_save
      after  :save,     :do_after_save

      before :delete,   :do_before_delete
      after  :delete,   :do_after_delete

      def validate
        super

        assert_present :body
      end

      def did?(action)
        instance_variable_get("@#{ action }")
      end

      def count(action)
        instance_variable_get("@#{ action }")
      end

    protected
      def do_before_validate() incr(:do_before_validate) end
      def do_after_validate()  incr(:do_after_validate)  end
      def do_before_create()   incr(:do_before_create)   end
      def do_after_create()    incr(:do_after_create)    end
      def do_before_save()     incr(:do_before_save)     end
      def do_after_save()      incr(:do_after_save)      end
      def do_before_delete()   incr(:do_before_delete)   end
      def do_after_delete()    incr(:do_after_delete)    end


      def incr(action)
        val = instance_variable_get("@#{ action }")
        val ||= 0
        val += 1

        instance_variable_set("@#{ action }", val)
      end
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

      should "call create / save callbacks only once" do
        assert_equal 1, @post.count(:do_before_create)
        assert_equal 1, @post.count(:do_after_create)
        assert_equal 1, @post.count(:do_before_save)
        assert_equal 1, @post.count(:do_after_create)
      end
    end

    context "on create when valid state" do
      setup do
        @post = Post.create(:body => "The Body")
      end

      should "call all callbacks" do
        assert @post.did?(:do_before_validate)
        assert @post.did?(:do_after_validate)
        assert @post.did?(:do_before_create)
        assert @post.did?(:do_after_create)
        assert @post.did?(:do_before_save)
        assert @post.did?(:do_after_save)
      end

      should "call create / save callbacks only once" do
        assert_equal 1, @post.count(:do_before_create)
        assert_equal 1, @post.count(:do_after_create)
        assert_equal 1, @post.count(:do_before_save)
        assert_equal 1, @post.count(:do_after_create)
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

      should "call save callbacks only once" do
        assert_equal 1, @post.count(:do_before_save)
        assert_equal 1, @post.count(:do_after_save)
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

    context "on delete" do
      setup do
        @post = Post.create(:body => "The Body")
        @post = Post[@post.id]
        @post.delete
      end


      should "call delete related callbacks once" do
        assert_equal 1, @post.count(:do_before_delete)
        assert_equal 1, @post.count(:do_after_delete)
      end

      should "not call all other callbacks" do
        assert ! @post.did?(:do_before_validate)
        assert ! @post.did?(:do_after_validate)
        assert ! @post.did?(:do_before_create)
        assert ! @post.did?(:do_after_create)
        assert ! @post.did?(:do_before_save)
        assert ! @post.did?(:do_after_save)
      end
    end
  end
end
