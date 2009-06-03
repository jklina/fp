class CreateFeatureds < ActiveRecord::Migration
  def self.up
    create_table :featureds do |t|
      t.column 			:comment,   				:text
	  t.column			:title,						:string
	  t.column			:user_id,					:int

      #magic names for timestamping
      t.column          :created_on,                :timestamp
      t.column          :updated_on,                :timestamp
    end
  end

  def self.down
    drop_table :featureds
  end
end
