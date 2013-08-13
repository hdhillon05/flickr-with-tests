class SessionsController < ApplicationController

  def new #login form rendered
    @user = User.new
  end

  def create #logs the user in
    @user = User.find_by(email: params[:user][:email]) #set the user by finding email
    
    #really hard to read so put in its own method -- if Rails.env.test? && params[:user][:password_digest]
    if @user && login_valid?(@user)
      session[:user_id] = @user.id
      redirect_to photos_path
    else
      flash[:error] = "Invalid username or password"
      redirect_to new_session_path #renders the new folder
        #render vs. redirect_to: redirect sends a new request - goes to new action and changes url and all
        #but render doesnt' change browser url, it keeps on page, it just returns NEW.HTML (i.e. the html)
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
