class ArchivesController < ApplicationController
  def show
    @posts = Post.published.order('published_at DESC').group_by { |post| post.published_at.year }
  end
end
