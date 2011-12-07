require 'test_helper'

class KindsControllerTest < ActionController::TestCase
  setup do
    @kind = kinds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:kinds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create kind" do
    assert_difference('Kind.count') do
      post :create, kind: @kind.attributes
    end

    assert_redirected_to kind_path(assigns(:kind))
  end

  test "should show kind" do
    get :show, id: @kind.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @kind.to_param
    assert_response :success
  end

  test "should update kind" do
    put :update, id: @kind.to_param, kind: @kind.attributes
    assert_redirected_to kind_path(assigns(:kind))
  end

  test "should destroy kind" do
    assert_difference('Kind.count', -1) do
      delete :destroy, id: @kind.to_param
    end

    assert_redirected_to kinds_path
  end
end
