require File.expand_path('../../test_helper', __FILE__)
#require File.dirname(__FILE__) + '../../test_helper'

class UserTest < Test::Unit::TestCase
  #fixtures :users
  
  context "a user" do
    setup do
      @user = Factory.create(:user, :username => 'fate0000', :password => 'password')
    end
  end

  # Replace this with your real tests.
  should "authenticate with matching username and password" do 
    assert_equal @user, User.authenticate('fate0000', 'password')
  end
  
  should "not authenticate with incorrect password" do 
    assert_equal nil, User.authenticate('fate0000', 'passwork')
  end
  
end
