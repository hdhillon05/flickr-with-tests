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
      post :create, photo: {title: "foo", description: "bar", price: "500"}
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

  test "should send email to user that creates a new photo" do
    login_as(:nick)

    ActionMailer::Base.deliveries.clear

    post :create, photo: { title: "test photo", description: "test description", upload: "some_upload.png", price: 5.00}

    email = UserMailer.new_photo_email(assigns[:current_user]).deliver
    assert !ActionMailer::Base.deliveries.empty?

    assert_equal ['test@flickrtest.com'], email.from
    assert_equal [assigns[:current_user].email], email.to
    assert_equal "Thanks for posting a new pic!", email.subject
  end

  test "test convert_price_to_cents function" do
    price = Photo.send :convert_price_to_cents, 19.99
    
    assert_equal price, 1999
  end

  test "price for photo should be converted to cents" do
    login_as(:nick)
    post :create, photo: { title: "test", description: "test", upload: "test.png", price: 5.99 }

    assert_equal 599, assigns[:photo].price
  end


end
