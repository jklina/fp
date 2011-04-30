class AddUserIdToNotifications < ActiveRecord::Migration
  def self.up
    add_column :notifications, :user_id, :integer
  end

  def self.down
    remove_column :notifications, :user_id
  end
end
