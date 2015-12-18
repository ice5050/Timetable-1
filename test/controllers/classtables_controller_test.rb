require 'test_helper'

class ClasstablesControllerTest < ActionController::TestCase

  setup do
    @user = users(:guest)
    @table = tables(:table_1)
    @classtable = classtables(:classtable_1)
  end

  test "should get index" do    
    get :index, user_id: @user, table_id: @table
    assert_response :success
  end

  test "should get new" do
    get :new, user_id: @user, table_id: @table, id: @classtable
    assert_response :success
  end

  test "should get edit" do
    get :edit, user_id: @user, table_id: @table, id: @classtable
    assert_response :success
  end

end
