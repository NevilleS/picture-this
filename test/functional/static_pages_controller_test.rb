require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "should get methods" do
    get :methods
    assert_response :success
  end

end
