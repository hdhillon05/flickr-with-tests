class SessionsController < ApplicationController

  def new #login form rendered
    @user = User.new
  end

  def create
    if env['omniauth.auth']
      user = User.from_omniauth(env['omniauth.auth'])
    else
      user = User.find_by(email: params[:user][:email])
      unless user && user.authenticate(params[:user][:password])
        user = nil
      end
    end
    if user
      session[:user_id] = user.id 
      redirect_to new_photo_path, notice: "Welcome! would you like to upload a new photo?"
    else
      flash[:error] = "Incorrect password."
      redirect_to new_session_path
    end
  end

  def destroy
    reset_session
    redirect_to new_session_path
  end

  private

  def login_valid?(user)
    if Rails.env.test? #if in test environment
      if params[:user][:password_digest] == user.password_digest
        return true
      end
    elsif @user.authenticate(params[:user][:password])
        return true
    end
  end

end
