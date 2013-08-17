class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.confirmation_email(@user).deliver
      respond_to do |format|
        format.html { redirect_to new_session_path, notice: "Please login with your newly created account a confirmation email will be sent to you shortly." }
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to action: :new }
        format.js
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :username, :password, :password_confirmation)
  end
end
