class AddViewsToTopic < ActiveRecord::Migration
  def self.up
    add_column :topics, :view, :integer, :null => false, :default => '0'
  end

  def self.down
    remove_column :topics, :view
  end
end
