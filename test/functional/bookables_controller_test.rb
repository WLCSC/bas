require 'test_helper'

class BookablesControllerTest < ActionController::TestCase
  setup do
    @bookable = bookables(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bookables)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bookable" do
    assert_difference('Bookable.count') do
      post :create, bookable: @bookable.attributes
    end

    assert_redirected_to bookable_path(assigns(:bookable))
  end

  test "should show bookable" do
    get :show, id: @bookable.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bookable.to_param
    assert_response :success
  end

  test "should update bookable" do
    put :update, id: @bookable.to_param, bookable: @bookable.attributes
    assert_redirected_to bookable_path(assigns(:bookable))
  end

  test "should destroy bookable" do
    assert_difference('Bookable.count', -1) do
      delete :destroy, id: @bookable.to_param
    end

    assert_redirected_to bookables_path
  end
end
