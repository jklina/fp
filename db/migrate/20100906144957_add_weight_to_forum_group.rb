class AddWeightToForumGroup < ActiveRecord::Migration
  def self.up
    add_column :forum_groups, :weight, :integer, :null => false, :default => '0'
  end

  def self.down
    remove_column :forum_groups, :weight
  end
end
