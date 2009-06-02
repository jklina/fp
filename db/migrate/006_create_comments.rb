class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.column			:user_id,					:integer
      t.column			:submission_id,				:integer
      t.column 			:comment,	 				:text

      #magic names for timestamping
      t.column          :created_on,                :timestamp
    end
  end

  def self.down
    drop_table :comments
  end
end
