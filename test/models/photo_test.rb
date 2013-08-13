require 'test_helper'

class PhotoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "search works" do
    photo = photos(:one)
    photo.title = 'nice title'
    photo.save

    search_results = Photo.search_for 'nice title'
    search_results_id = search_results.map{|search_result| search_result.id }
    assert search_results_id.include?(photo.id)
  end

end
