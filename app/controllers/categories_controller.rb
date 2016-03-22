class CategoriesController < ApplicationController
  def show
    @tag = params[:tag]
    @posts = Post.published.where("? = ANY (tags)", @tag).order('published_at DESC').group_by { |post| post.published_at.year }
  end
end
