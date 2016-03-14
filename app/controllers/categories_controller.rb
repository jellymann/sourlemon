class CategoriesController < ApplicationController
  def show
    @tag = params[:tag]
    @posts = Post.where("? = ANY (tags)", @tag).order('created_at DESC').group_by { |post| post.created_at.year }
  end
end
