require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "new renders login form" do
    get :new
    assert_response :success
  end

  test "create with invalid params renders errors" do
    post :create, user: {email: "foo", password: "bar"} #put in an invalid email/password
    assert flash[:error] #just make sure something in the flasherror
    assert_redirected_to new_session_path #if the login fails, then render the form again
  end

  test "create with valid params (email and pw) sets session" do
    #we attempted to stub authenticate method here -- but could not get it working. Check this out later, Nick says this is the most correct way.
    user = users(:nick)
    post :create, username: user.username, password: user.password
  end

  test "destroy clears the sesssion" do
    session[:user_id] = 5
    get :destroy
    assert_nil session[:user_id]
  end
end
