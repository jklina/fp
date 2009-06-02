class CreateFeaturedAssociations < ActiveRecord::Migration
  def self.up
    create_table :featured_associations do |t|
	
	  t.column		:submission_id,		:integer
	  t.column		:featured_id,		:integer

      t.timestamps
    end
  end

  def self.down
    drop_table :featured_associations
  end
end
