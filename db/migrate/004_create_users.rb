class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column  :username,			:string
	  t.column  :name, 				:string
  	  t.column  :last_login_time,	:timestamp
  	  t.column  :location,			:string
  	  t.column  :country,			:string
  	  t.column  :email,				:string
  	  t.column  :aim,				:string
  	  t.column  :msn,				:string
  	  t.column  :icq,				:string
  	  t.column  :yahoo,				:string
  	  t.column  :website,			:string
  	  t.column  :current_projects,	:text
	  
      t.column  :average_rating,					:float
	  t.column  :average_rating_lower_bound,		:float
	  t.column  :average_rating_upper_bound,		:float
      t.column  :average_admin_rating,				:float
	  t.column  :average_admin_rating_lower_bound,	:float
	  t.column  :average_admin_rating_upper_bound,	:float
	  
  	  #Access Level levels:
  	  #1 = Normal User
  	  #2 = Admin
  	  #3 = Super Admin
	  
  	  t.column	:access_level,				:integer, 		:default => 1
	  
      t.column  :email_confirmation,		:boolean,		:default => false
      t.column  :email_confirmation_salt, 	:string 
      t.column  :email_confirmation_hash,	:string
	 
      t.column  :password_salt, 	:string
      t.column  :password_hash,		:string
      
  	  t.column	:created_at, 		:timestamp
  	  t.column	:updated_at, 		:timestamp
    end
  end

  def self.down
    drop_table :users
  end
end
