require 'test_helper'

class ActionInventoryObjectsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:action_inventory_objects)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create action_inventory_objects" do
    assert_difference('ActionInventoryObjects.count') do
      post :create, :action_inventory_objects => { }
    end

    assert_redirected_to action_inventory_objects_path(assigns(:action_inventory_objects))
  end

  test "should show action_inventory_objects" do
    get :show, :id => action_inventory_objects(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => action_inventory_objects(:one).to_param
    assert_response :success
  end

  test "should update action_inventory_objects" do
    put :update, :id => action_inventory_objects(:one).to_param, :action_inventory_objects => { }
    assert_redirected_to action_inventory_objects_path(assigns(:action_inventory_objects))
  end

  test "should destroy action_inventory_objects" do
    assert_difference('ActionInventoryObjects.count', -1) do
      delete :destroy, :id => action_inventory_objects(:one).to_param
    end

    assert_redirected_to action_inventory_objects_path
  end
end
