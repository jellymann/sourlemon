class PostsController < ApplicationController
  def index
    @posts = Post.published
  end
end
