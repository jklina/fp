require File.expand_path('../../test_helper', __FILE__)
#require File.dirname(__FILE__) + '../../test_helper'

class UserTest < Test::Unit::TestCase
  #fixtures :users

  # Replace this with your real tests.
  should "authenticate with matching username and password" do 
    user=Factory.create(:user, :username => 'fate0000', :password => 'password')
    assert_equal user, User.authenticate('fate0000', 'password')
  end
  
  should "not authenticate with incorrect password" do 
    user=Factory.create(:user, :username => 'fate0000', :password => 'password')
    assert_equal nil, User.authenticate('fate0000', 'passwork')
  end
  
end
