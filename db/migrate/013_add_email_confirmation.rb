class AddEmailConfirmation < ActiveRecord::Migration
  def self.up
    #add_column :users, :email_confirmation, :boolean, :default => false
	
    #add_column  :users, :email_confirmation_salt, 	:string 
    #add_column  :users, :email_confirmation_hash,		:string
  end

  def self.down
    #remove_column :users, :email_confirmation
	#remove_column :users, :email_confirmation_salt 
	#remove_column :users, :email_confirmation_hash
  end
end
