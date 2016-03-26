require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:published)
  end

  test "should get index" do
    get root_url
    assert_response :success
  end

  test "should show post" do
    get @post.slug_path
    assert_response :success
  end

  test "should respond to unpublished post with 404" do
    assert_raises(ActionController::RoutingError) { get posts(:unpublished).slug_path }
  end

  # TODO: figure out how to sign in
  # test "should get new if signed in" do
  #   sign_in user(:bob)
  #
  #   get new_post_url
  #   assert_response :success
  # end
  #
  # test "should create post if signed in" do
  #   sign_in user(:bob)
  #
  #   assert_difference('Post.count', +1) do
  #     post posts_url, params: { post: {
  #       body: @post.body,
  #       title: @post.title,
  #       tags_csv: "foo,bar"
  #     } }
  #   end
  #
  #   assert_equal ["foo", "bar"], Post.last.tags
  #   assert_redirected_to post_path(Post.last)
  # end
  #
  # test "should get edit if signed in" do
  #   sign_in user(:bob)
  #
  #   get edit_post_url(@post)
  #   assert_response :success
  # end
  #
  # test "should update post if signed in" do
  #   sign_in user(:bob)
  #
  #   patch post_url(@post), params: { post: { body: @post.body, title: @post.title } }
  #   assert_redirected_to post_path(@post)
  # end
  #
  # test "should destroy post if signed in" do
  #   sign_in user(:bob)
  #
  #   assert_difference('Post.count', -1) do
  #     delete post_url(@post)
  #   end
  #
  #   assert_redirected_to posts_path
  # end

  test "should respond to create with 404 if not logged in" do
    assert_raises(ActionController::RoutingError) { post posts_url }
  end
  test "should respon to edit with 404 if not logged in" do
    assert_raises(ActionController::RoutingError) { get edit_post_url(@post) }
  end
  test "should respon to update with 404 if not logged in" do
    assert_raises(ActionController::RoutingError) { patch post_url(@post) }
  end
  test "should respon to destroy with 404 if not logged in" do
    assert_raises(ActionController::RoutingError) { delete post_url(@post) }
  end
end
