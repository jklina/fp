class CreateUserImages < ActiveRecord::Migration
  def self.up
    create_table :user_images do |t|
      
      # Child of a user
  	    t.column :user_id,      :integer

  	  # Image Attributes
        t.column :filename,     :string
        t.column :content_type, :string
        t.column :size,         :integer
        t.column :width,        :integer
        t.column :height,       :integer
        t.column :parent_id,    :integer
        t.column :thumbnail,    :string
        t.column :created_at,   :datetime
      end
  end

  def self.down
    drop_table :user_images
  end
end
