require 'test_helper'

class SearchControllerTest < ActionController::TestCase

    setup do 
        @user = users(:guest)
        @table = tables(:table_1)
    end

    test "should get index current_path => classtatables" do
        get :index, user_id: @user, id: @table
        assert_response :redirect
    end

    test "should get index current_path => other" do
        get :index
        assert_response :redirect
    end

end
