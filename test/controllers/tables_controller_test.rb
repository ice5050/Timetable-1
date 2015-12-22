require 'test_helper'

class TablesControllerTest < ActionController::TestCase

  setup do
    @user = users(:guest)
    @table = tables(:table_1)    
  end

  test "should get index" do
    get :index, user_id: @user
    assert_response :success
  end

  test "should get new" do
    get :new, user_id: @user, id: @table
    assert_response :success
  end

  test "should get edit" do
    get :edit, user_id: @user, id: @table
    assert_response :success
  end

  test "should get reset" do
    get :reset, user_id: @user, id: @table
    assert_redirected_to controller: 'classtables', action: 'index', table_id: @table.id
  end

end
