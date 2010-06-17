class AddForeignToForums < ActiveRecord::Migration
  def self.up
    add_column :forums, :forum_group_id, :integer
  end

  def self.down
    remove_column :forums, :forum_group_id
  end
end
