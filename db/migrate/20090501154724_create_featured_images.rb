class CreateFeaturedImages < ActiveRecord::Migration
  def self.up
    create_table :featured_images do |t|
      
	  #Child of a Featured.
	  t.column :featured_id,  :integer
	  
      t.column :parent_id,    :integer
	  t.column :content_type, :string
      t.column :filename, :string    
      t.column :thumbnail, :string 
      t.column :size, :integer
      t.column :width, :integer
      t.column :height, :integer

      t.timestamps
    end
  end

  def self.down
    drop_table :featured_images
  end
end
