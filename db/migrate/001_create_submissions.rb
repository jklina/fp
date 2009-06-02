class CreateSubmissions < ActiveRecord::Migration
  def self.up
    create_table :submissions do |t|
      t.column 			:title,						:string
      t.column 			:description, 				:text
       t.column			:category_id,					:integer

      #magic names for timestamping
      t.column          :created_on,                :timestamp
      t.column          :updated_on,                :timestamp
    end
  end

  def self.down
    drop_table :submissions
  end
end
