class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :slug_path

  def slug_path(post)
    if post.published?
      post.slug_path
    else
      unpublished_post_path(post)
    end
  end
end
