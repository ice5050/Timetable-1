require 'test_helper'

class StudentsControllerTest < ActionController::TestCase
  test "should get index" do
    user = users(:admin)
    url = "https://www3.reg.cmu.ac.th/regist258/public/stdtotal.php?var=add&COURSENO=204100&SECLEC=001&SECLAB=000"
    get :index, user_id: user, url: url, code: 204100
    assert_response :success
  end

end
