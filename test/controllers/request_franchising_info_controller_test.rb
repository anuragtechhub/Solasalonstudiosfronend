require 'test_helper'

class RequestFranchisingInfoControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
