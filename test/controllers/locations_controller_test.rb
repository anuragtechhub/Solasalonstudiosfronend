require 'test_helper'

class LocationsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get city" do
    get :city
    assert_response :success
  end

  test "should get state" do
    get :state
    assert_response :success
  end

  test "should get salon" do
    get :salon
    assert_response :success
  end

end
