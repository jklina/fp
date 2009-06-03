class CreateRatings < ActiveRecord::Migration
  def self.up
    create_table :ratings do |t|
      t.column			:user_id,					:integer
      t.column			:submission_id,				:integer
      
	  t.column 			:rating,	 				:integer
	  t.column			:admin, 					:boolean
	  
	  t.column			:rated_user_id,				:int

      t.timestamps
    end
  end

  def self.down
    drop_table :ratings
  end
end
