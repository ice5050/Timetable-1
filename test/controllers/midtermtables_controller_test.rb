require 'test_helper'

class MidtermtablesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
