require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/base_controller_controller'

# Re-raise errors caught by the controller.
class Admin::BaseControllerController; def rescue_action(e) raise e end; end

class Admin::BaseControllerControllerTest < Test::Unit::TestCase
  def setup
    @controller = Admin::BaseControllerController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end