require 'test_helper'

class FinaltablesControllerTest < ActionController::TestCase
    
    setup do
        @user = users(:guest)
        @table = tables(:table_1)
    end

    test "should get index" do
        get :index, user_id: @user, table_id: @table
        assert_response :success
    end

end
