require "helper"

class TestOhmWebValidations < Test::Unit::TestCase
  class BlogPost < Ohm::Model
    include Ohm::WebValidations

    attribute :slug

    index :slug

    def validate
    assert_slug :slug
    end
  end

  class Comment < Ohm::Model
    include Ohm::WebValidations

    attribute :ip_address
    attribute :homepage
    attribute :email

    def validate
      assert_ipaddr :ip_address
      assert_url :homepage
      assert_email :email
    end
  end

  context "The slug should be valid" do
    def setup
      Ohm.flush
      @blog_post_01 = BlogPost.new
      @blog_post_02 = BlogPost.new
    end

    should "fail if the slug is not valid" do
      @blog_post_01.slug = "This is a title, not a SLUG"
      @blog_post_01.create

      assert @blog_post_01.new?
      assert_equal [[:slug, :not_slug]], @blog_post_01.errors
    end

    should "succeed if the slug is valid" do
      @blog_post_02.slug = "this-is-a-valid-slug"
      @blog_post_02.create
      assert_not_nil @blog_post_02.id
    end

    should "fail if the slug is not unique" do

      @blog_post_01.slug = "this-is-a-valid-slug"
      @blog_post_01.create

      @blog_post_02.slug = "this-is-a-valid-slug"
      @blog_post_02.create

      assert @blog_post_02.new?
      assert_equal [[:slug, :not_unique]], @blog_post_02.errors
    end
  end

  context "the ip address should be valid" do
    def setup
      @comment = Comment.new
    end

    should "fail if the ip address is not valid" do
      @comment.ip_address = "400.500.600.700"
      @comment.create

      assert @comment.new?
      assert @comment.errors.include? [:ip_address, :not_ipaddr]
    end
  end

  context "the email address should be valid" do
    def setup
      @comment = Comment.new
    end

    should "fail if the email address is not valid" do
      @comment.email = "something.com"
      @comment.create

      assert @comment.new?
      assert @comment.errors.include? [:email, :not_email]
    end
  end

  context "the homepage URL should be valid" do
    def setup
      @comment = Comment.new
    end

    should "fail if the homepage URL is not valid" do
      @comment.homepage = "something"
      @comment.create

      assert @comment.new?
      assert @comment.errors.include? [:homepage, :not_url]
    end

    should "fail if the homepage URL protocol is not http or https" do
      @comment.homepage = "irc://irc.freenode.net/something"
      @comment.create

      assert @comment.new?
      assert @comment.errors.include? [:homepage, :not_url]
    end

  end
end