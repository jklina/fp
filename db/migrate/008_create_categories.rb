class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.column 			:title,						:string
      t.column 			:description, 					:text

      #magic names for timestamping
      t.column          :created_on,                :timestamp
      t.column          :updated_on,                :timestamp
    end
  end

  def self.down
    drop_table :categories
  end
end
