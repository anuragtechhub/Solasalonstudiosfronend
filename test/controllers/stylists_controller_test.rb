require 'test_helper'

class StylistsControllerTest < ActionController::TestCase
  setup do
    @stylist = stylists(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stylists)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stylist" do
    assert_difference('Stylist.count') do
      post :create, stylist: { accepting_new_clients: @stylist.accepting_new_clients, biography: @stylist.biography, booking_url: @stylist.booking_url, brows: @stylist.brows, business_name: @stylist.business_name, email_address: @stylist.email_address, eyelash_extensions: @stylist.eyelash_extensions, hair: @stylist.hair, makeup: @stylist.makeup, massage: @stylist.massage, nails: @stylist.nails, name: @stylist.name, phone_number: @stylist.phone_number, skin: @stylist.skin, studio_number: @stylist.studio_number, tanning: @stylist.tanning, teeth_whitening: @stylist.teeth_whitening, url_name: @stylist.url_name, waxing: @stylist.waxing, website: @stylist.website, work_hours: @stylist.work_hours }
    end

    assert_redirected_to stylist_path(assigns(:stylist))
  end

  test "should show stylist" do
    get :show, id: @stylist
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @stylist
    assert_response :success
  end

  test "should update stylist" do
    patch :update, id: @stylist, stylist: { accepting_new_clients: @stylist.accepting_new_clients, biography: @stylist.biography, booking_url: @stylist.booking_url, brows: @stylist.brows, business_name: @stylist.business_name, email_address: @stylist.email_address, eyelash_extensions: @stylist.eyelash_extensions, hair: @stylist.hair, makeup: @stylist.makeup, massage: @stylist.massage, nails: @stylist.nails, name: @stylist.name, phone_number: @stylist.phone_number, skin: @stylist.skin, studio_number: @stylist.studio_number, tanning: @stylist.tanning, teeth_whitening: @stylist.teeth_whitening, url_name: @stylist.url_name, waxing: @stylist.waxing, website: @stylist.website, work_hours: @stylist.work_hours }
    assert_redirected_to stylist_path(assigns(:stylist))
  end

  test "should destroy stylist" do
    assert_difference('Stylist.count', -1) do
      delete :destroy, id: @stylist
    end

    assert_redirected_to stylists_path
  end
end
