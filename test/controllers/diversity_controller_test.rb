require 'test_helper'

class DiversityControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
