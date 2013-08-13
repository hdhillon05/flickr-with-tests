require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "#new works" do
    get :new

    assert_response :ok
  end

  test "/new route exists" do
    assert_generates '/users/new', controller: 'users', action: 'new'
  end

  test "#create works with valid attributes" do
    attributes = valid_user_attributes

    assert_difference "User.count" do
      post :create, user: attributes
    end
  end

  test "#create fails gracefully with invalid attributes" do
    attributes = invalid_user_attributes

    assert_difference "User.count", 0 do
      post :create, user: attributes
    end

    assert_template :new
  end

  test "sends email when user created" do
    user = users(:nick)
    ActionMailer::Base.deliveries.clear
    assert_difference 'ActionMailer::Base.deliveries.size' do
      post :create, user: {username: 'bob', email: 'bob@fake.com', password: 'valid_password', password_confirmation: 'valid_password' }
      #note: needed to create a brand new user with fresh information b/c under user model we have validated for uniqueness of username
    end
    
    email_confirmation = ActionMailer::Base.deliveries.last

    assert_equal ['bob@fake.com'], email_confirmation.to #using an array for 'harman@fake.com' b/c email_confirmation.to returns an array
    assert_equal 'Welcome to FlickrApp', email_confirmation.subject
    assert_equal ['test@flickrtest.com'], email_confirmation.from
  end

  def valid_user_attributes
    user = users(:nick)
    attributes = user.attributes.except("id")
    attributes[:password] = "foo"
    attributes[:password_confirmation] = "foo"
    user.destroy!

    raise unless User.new(attributes).valid?

    return attributes
  end

  def invalid_user_attributes
    attributes = valid_user_attributes
    attributes[:username] = nil

    raise if User.new(attributes).valid?

    return attributes
  end
end
