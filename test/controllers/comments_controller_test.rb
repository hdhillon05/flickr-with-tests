require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "cannot access comments index unless logged in" do
    get :index, photo_id: photos(:one).id
    assert_redirected_to new_session_path
  end

  # NOTE: THIS IS HOW YOU TEST A POLYMORPHIC ASSOCIATION - YOU ARE PASSING THE PHOTOS ID - AM NOT USING THIS TEST BECAUSE I AM NOT USING A "NEW" ACTION OR COMMENTS - INSTEAD THE COMMENTS FIELD IS DISPLAYED IN THE FORM ON THE SHOW PAGE FOR PHOTOS - WHEN THAT IS SUBMITTED IT IS ROUTED TO COMMENTS/CREATE ACTION
  # test "get new action to create a comment" do
  #   login_as(:nick)
  #   get :new, photo_id: photos(:one).id
  #   assert_response :success
  # end

  test "should not be able to comment unless logged in" do
    assert_no_difference "Comment.count" do
      post :create, photo_id: photos(:one).id, comment: {body: "foo"}, commentable: "photos"
    end
    assert_redirected_to new_session_path
  end


  #NOTE: This is how you test a create action for a polymorphic model - in this case, it's creating a comment for a photo (which is commentable)
  test "creates a new comment" do
    login_as(:nick)
    assert_difference "Comment.count" do
      post :create, photo_id: photos(:one).id, comment: {body: "foo"}, commentable: "photos"
    end
    assert_redirected_to photo_path(assigns(:comment).commentable)
  end


  

end
