require 'test_helper'

class NewsletterControllerTest < ActionController::TestCase
  test "should get sign-up" do
    get :sign-up
    assert_response :success
  end

end
