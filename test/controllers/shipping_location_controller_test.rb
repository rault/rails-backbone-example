require 'test_helper'

class ShippingLocationControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get shipping_location_index_url
    assert_response :success
  end

  test "should get new" do
    get shipping_location_new_url
    assert_response :success
  end

  test "should get show" do
    get shipping_location_show_url
    assert_response :success
  end

  test "should get update" do
    get shipping_location_update_url
    assert_response :success
  end

end
