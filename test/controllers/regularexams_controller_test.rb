require 'test_helper'

class RegularexamsControllerTest < ActionController::TestCase
  test "should get index" do
        @user = users(:admin)
        sign_in :user, @user 

        get :index
        assert_response :success
    end

    test "shouldn't get index" do
        @guest = users(:guest)
        sign_in :user, @guest 

        get :index
        assert_redirected_to homepages_path
    end

end
