require 'test_helper'

class SpatulaControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get spatula_index_url
    assert_response :success
  end

  test "should get new" do
    get spatula_new_url
    assert_response :success
  end

  test "should get show" do
    get spatula_show_url
    assert_response :success
  end

  test "should get update" do
    get spatula_update_url
    assert_response :success
  end

end
