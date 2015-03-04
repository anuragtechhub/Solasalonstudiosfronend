require 'test_helper'

class TourControllerTest < ActionController::TestCase
  test "should get request" do
    get :request
    assert_response :success
  end

end
