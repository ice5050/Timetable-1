require 'test_helper'

class GeneratesControllerTest < ActionController::TestCase
    setup do
        @user = users(:guest)
    end

    test "should get index without login" do       
        get :index
        assert_response :success
    end

    test "should get index with login" do       
        get :index, id: @user
        assert_response :success
    end

end
