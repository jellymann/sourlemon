class UnpublishedPostsController < ApplicationController
  before_action :check_user_auth

  def index
    @posts = Post.unpublished.order('created_at DESC').group_by { |post| post.created_at.year }
  end

  def show
    @post = Post.unpublished.find(params[:id])
  end

  private

  def check_user_auth
    raise ActionController::RoutingError.new('Not Found') unless user_signed_in?
  end
end
