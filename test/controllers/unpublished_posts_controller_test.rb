require 'test_helper'

class UnpublishedPostsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @post = posts(:unpublished)
  end

  # TODO: figure out how to sign in
  #
  # test "should get index" do
  #   get unpublished_posts_path
  #   assert_response :success
  # end
  #
  # test "should show post" do
  #   get unpublished_post_path(@post)
  #   assert_response :success
  # end
  #
  # test "should respond to published post with 404" do
  #   assert_raises(ActionController::RoutingError) { get unpublished_post_path(:published) }
  # end

  test "should respond to index with 404 if not signed in" do
    assert_raises(ActionController::RoutingError) { get unpublished_posts_path }
  end

  test "should respond to show with 404 if not signed in" do
    assert_raises(ActionController::RoutingError) { get unpublished_post_path(@post) }
  end
end
