class CreateSubmissionAssociations < ActiveRecord::Migration
  def self.up
    create_table :submission_associations do |t|
	
	  t.column		:submission_id,		:integer
	  t.column		:user_id,			:integer
	  
	  t.column		:created_at, 		:timestamp
	  t.column		:updated_at, 		:timestamp
	  
    end
  end

  def self.down
    drop_table :submission_associations
  end
end
