class ApplicationController < ActionController::Base
  before_action :check_user

  helper_method :current_user, :user_signed_in?

  attr_reader :current_user

  def check_user
    return unless session[:current_user_id]

    @current_user = User.find_by_id(session[:current_user_id])
  end

  def user_signed_in?
    !current_user.nil?
  end
end
