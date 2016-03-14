class ArchivesController < ApplicationController
  def show
    @posts = Post.all.order('created_at DESC').group_by { |post| post.created_at.year }
  end
end
