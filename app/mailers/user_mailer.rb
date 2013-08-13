class UserMailer < ActionMailer::Base
  default from: "test@flickrtest.com"

  def confirmation_email(user)
    @user = user
    mail(to: user.email, subject: 'Welcome to FlickrApp')
  end

  def new_photo_email(user)
    @user = user
    mail(to: user.email, subject: "Thanks for posting a new pic!")
  end

end
