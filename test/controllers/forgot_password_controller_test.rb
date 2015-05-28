require 'test_helper'

class ForgotPasswordControllerTest < ActionController::TestCase
  test "should get request" do
    get :request
    assert_response :success
  end

  test "should get reset" do
    get :reset
    assert_response :success
  end

end
