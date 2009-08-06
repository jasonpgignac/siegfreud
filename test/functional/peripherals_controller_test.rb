require 'test_helper'

class PeripheralsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:peripherals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create peripheral" do
    assert_difference('Peripheral.count') do
      post :create, :peripheral => { }
    end

    assert_redirected_to peripheral_path(assigns(:peripheral))
  end

  test "should show peripheral" do
    get :show, :id => peripherals(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => peripherals(:one).to_param
    assert_response :success
  end

  test "should update peripheral" do
    put :update, :id => peripherals(:one).to_param, :peripheral => { }
    assert_redirected_to peripheral_path(assigns(:peripheral))
  end

  test "should destroy peripheral" do
    assert_difference('Peripheral.count', -1) do
      delete :destroy, :id => peripherals(:one).to_param
    end

    assert_redirected_to peripherals_path
  end
end
