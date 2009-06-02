require File.dirname(__FILE__) + '/../../test_helper'
require 'super_admin/user_controller'

# Re-raise errors caught by the controller.
class SuperAdmin::UserController; def rescue_action(e) raise e end; end

class SuperAdmin::UserControllerTest < Test::Unit::TestCase
  def setup
    @controller = SuperAdmin::UserController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
