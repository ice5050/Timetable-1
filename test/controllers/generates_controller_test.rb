require 'test_helper'

class GeneratesControllerTest < ActionController::TestCase
    setup do
        @user = users(:guest)
    end

    test "should get index without login" do       
        get :index, semester: 1, year: 2, stu_id: 570510659
        assert_response :success
    end

    test "should get index with login" do       
        get :index, id: @user, semester: 1, year: 2, stu_id: 570510659
        assert_response :success
    end

end
