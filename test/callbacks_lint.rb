test "save on invalid" do
  post = Post.new
  post.save

  assert post.did?(:do_before_validate)
  assert post.did?(:do_after_validate)

  assert ! post.did?(:do_before_create)
  assert ! post.did?(:do_after_create)
  assert ! post.did?(:do_before_save)
  assert ! post.did?(:do_after_save)
  assert ! post.did?(:do_before_update)
  assert ! post.did?(:do_after_update)
end

test "saving a valid model" do
  post = Post.new(:body => "The Body")
  post.save

  assert post.did?(:do_before_validate)
  assert post.did?(:do_after_validate)
  assert post.did?(:do_before_create)
  assert post.did?(:do_after_create)
  assert post.did?(:do_before_save)
  assert post.did?(:do_after_save)
  assert ! post.did?(:do_before_update)
  assert ! post.did?(:do_after_update)
end

test "ensure create / save callbacks are only called once" do
  post = Post.new(:body => "The Body")
  post.save

  assert 1 == post.count(:do_before_create)
  assert 1 == post.count(:do_after_create)
  assert 1 == post.count(:do_before_save)
  assert 1 == post.count(:do_after_create)
end

test "Post::create on a valid model invokes all callbacks (except update)" do
  post = Post.create(:body => "The Body")

  assert post.did?(:do_before_validate)
  assert post.did?(:do_after_validate)
  assert post.did?(:do_before_create)
  assert post.did?(:do_after_create)
  assert post.did?(:do_before_save)
  assert post.did?(:do_after_save)
  assert ! post.did?(:do_before_update)
  assert ! post.did?(:do_after_update)
end

test "ensure Post::create only invokes save / create once" do
  post = Post.create(:body => "The Body")

  assert 1 == post.count(:do_before_create)
  assert 1 == post.count(:do_after_create)
  assert 1 == post.count(:do_before_save)
  assert 1 == post.count(:do_after_create)
end

test "on successful save of existing record" do
  post = Post.create(:body => "The Body")
  post = Post[post.id]
  post.save

  assert ! post.did?(:do_before_create)
  assert ! post.did?(:do_after_create)

  assert post.did?(:do_before_validate)
  assert post.did?(:do_after_validate)
  assert post.did?(:do_before_save)
  assert post.did?(:do_after_save)
  assert post.did?(:do_before_update)
  assert post.did?(:do_after_update)

  assert 1 == post.count(:do_before_save)
  assert 1 == post.count(:do_after_save)
  assert 1 == post.count(:do_before_update)
  assert 1 == post.count(:do_after_update)
end

test "on successful save of existing record (using #update)" do
  post = Post.create(:body => "The Body")
  post = Post[post.id]
  post.update(:body => "New Body")

  assert ! post.did?(:do_before_create)
  assert ! post.did?(:do_after_create)

  assert post.did?(:do_before_validate)
  assert post.did?(:do_after_validate)
  assert post.did?(:do_before_save)
  assert post.did?(:do_after_save)
  assert post.did?(:do_before_update)
  assert post.did?(:do_after_update)

  assert 1 == post.count(:do_before_save)
  assert 1 == post.count(:do_after_save)
  assert 1 == post.count(:do_before_update)
  assert 1 == post.count(:do_after_update)
end

test "on failed save of existing record" do
  post = Post.create(:body => "The Body")
  post = Post[post.id]

  post.body = nil
  post.save

  assert post.did?(:do_before_validate)
  assert post.did?(:do_after_validate)

  assert ! post.did?(:do_before_create)
  assert ! post.did?(:do_after_create)

  assert ! post.did?(:do_before_save)
  assert ! post.did?(:do_after_save)

  assert ! post.did?(:do_before_update)
  assert ! post.did?(:do_after_update)
end

test "on delete" do
  post = Post.create(:body => "The Body")
  post = Post[post.id]
  post.delete

  assert 1 == post.count(:do_before_delete)
  assert 1 == post.count(:do_after_delete)

  assert ! post.did?(:do_before_validate)
  assert ! post.did?(:do_after_validate)
  assert ! post.did?(:do_before_create)
  assert ! post.did?(:do_after_create)
  assert ! post.did?(:do_before_save)
  assert ! post.did?(:do_after_save)
  assert ! post.did?(:do_before_update)
  assert ! post.did?(:do_after_update)
end

