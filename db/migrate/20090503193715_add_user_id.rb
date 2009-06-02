class AddUserId < ActiveRecord::Migration
  def self.up
    add_column :featureds, :user_id, :int
  end

  def self.down
    remove_column :featureds, :user_id
  end
end
