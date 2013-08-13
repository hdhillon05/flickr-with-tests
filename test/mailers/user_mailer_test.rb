require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  # test "the truth" do
  #   assert true
  # end

  tests UserMailer

  test "new user confirmation email is sent" do
    user = users(:nick)

    email = UserMailer.confirmation_email(user).deliver
    assert !ActionMailer::Base.deliveries.empty?

    assert_equal ['test@flickrtest.com'], email.from
    assert_equal [user.email], email.to
    assert_equal 'Welcome to FlickrApp', email.subject
    #assert_equal read_fixture('confirmation').join, email.body.to_s
  end

end
