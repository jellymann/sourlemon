class SessionsController < ApplicationController
  def new
    redirect_to root_path, notice: 'You are already signed in' if user_signed_in?
  end

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      @current_user = user
      session[:current_user_id] = user.id
      redirect_to root_path, notice: 'Successfully signed in'
    else
      flash.now[:alert] = 'Incorrect email or password'
      render :new
    end
  end

  def destroy
    session[:current_user_id] = nil
    redirect_to root_path, notice: 'Successfully signed out'
  end
end
