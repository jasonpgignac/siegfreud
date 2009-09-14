require 'test_helper'

class PackageMapsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:package_maps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create package_map" do
    assert_difference('PackageMap.count') do
      post :create, :package_map => { }
    end

    assert_redirected_to package_map_path(assigns(:package_map))
  end

  test "should show package_map" do
    get :show, :id => package_maps(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => package_maps(:one).to_param
    assert_response :success
  end

  test "should update package_map" do
    put :update, :id => package_maps(:one).to_param, :package_map => { }
    assert_redirected_to package_map_path(assigns(:package_map))
  end

  test "should destroy package_map" do
    assert_difference('PackageMap.count', -1) do
      delete :destroy, :id => package_maps(:one).to_param
    end

    assert_redirected_to package_maps_path
  end
end
