class AddAdminUser < ActiveRecord::Migration
  def self.up
    User.create(:username => 'admin', :name => 'admins', :email => 'jlfds@jklfds.com', :access_level => 3, :password => 'secret', :password_confirmation => 'secret', :email_confirmation => true)
  end

  def self.down
  end
end
