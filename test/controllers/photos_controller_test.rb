require 'test_helper'

class PhotosControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end

  #NOTE: login_as() is a method w defined in the test_helper.rb file --IT'S AVAILABLE TO ALL HELPERS THAT WAY

  test "cannot access photos index if not logged in" do
    get :index
    assert_redirected_to new_session_path
  end

  test "new shows photo upload form" do
    login_as(:nick) #method defined in test_helper.rb
    get :new
    assert_response :ok
  end

  test "create should create a photo record in photo database" do
    login_as(:nick)
    assert_difference "Photo.count" do
      post :create, photo: {title: "foo", description: "bar"}
    end
    photo = assigns(:photo)
    assert photo.user #assert that photo has a user
    assert_redirected_to photo_path(assigns(:photo))
  end

  test "show works" do
    #note: we don't require login_as her b/c we don't want ot require them to login to viwe other user's photos
    get :show, id: photos(:one).id
    assert_response :ok
    assert assigns(:photo)
  end

  test "show should find a photo and render html" do
    photo = photos(:one)
    photo.title = "nice title"
    photo.save

    post :search, query: "nice title"

    search_results = assigns["results"]
    search_results_ids = search_results.map {|search_result| search_result.id}
    assert search_results_ids.include?(photo.id)
  end


end
