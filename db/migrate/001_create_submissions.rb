class CreateSubmissions < ActiveRecord::Migration
  def self.up
    create_table :submissions do |t|
      t.column 			:title,						:string
      t.column 			:description, 				:text
	  t.column			:category_id,				:integer
	  t.column			:views,						:integer, :default => 0
	  t.column			:downloads,					:integer, :default => 0
	  t.column			:owner_trash,				:bool
	  t.column			:moderator_trash,			:bool
	  
      t.column			:average_rating,					:float
	  t.column			:average_rating_lower_bound,		:float
	  t.column			:average_rating_upper_bound,		:float
      t.column			:average_admin_rating,				:float
	  t.column			:average_admin_rating_lower_bound,	:float
	  t.column			:average_admin_rating_upper_bound,	:float

      #magic names for timestamping
      t.column          :created_on,                :timestamp
      t.column          :updated_on,                :timestamp
    end
  end

  def self.down
    drop_table :submissions
  end
end
