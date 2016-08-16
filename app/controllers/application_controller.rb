class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :slug_path, :in_mobile_app?, :mobile_app_version

  MOBILE_APP_RGX = /SourLemon\/(\d+\.\d+)/

  def slug_path(post)
    if post.published?
      post.slug_path
    else
      unpublished_post_path(post)
    end
  end

  def in_mobile_app?
    !!(request.user_agent =~ MOBILE_APP_RGX)
  end

  def mobile_app_version
    request.user_agent =~ MOBILE_APP_RGX && $1
  end
end
