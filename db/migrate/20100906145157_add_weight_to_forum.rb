class AddWeightToForum < ActiveRecord::Migration
  def self.up
    add_column :forums, :weight, :integer, :null => false, :default => '0'
  end

  def self.down
    remove_column :forums, :weight
  end
end
