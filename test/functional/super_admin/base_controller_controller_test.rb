require File.dirname(__FILE__) + '/../../test_helper'
require 'super_admin/base_controller_controller'

# Re-raise errors caught by the controller.
class SuperAdmin::BaseControllerController; def rescue_action(e) raise e end; end

class SuperAdmin::BaseControllerControllerTest < Test::Unit::TestCase
  def setup
    @controller = SuperAdmin::BaseControllerController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
