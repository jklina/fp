class AddAdminUser < ActiveRecord::Migration
  def self.up
    User.create(:name => 'admins', :email => 'jlfds@jklfds.com', :access_level => 3, :password => 'secret', :password_confirmation => 'secret')
  end

  def self.down
  end
end
