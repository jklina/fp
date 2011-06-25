class AddInitiatorIdToNotifications < ActiveRecord::Migration
  def self.up
    add_column :notifications, :initiator_id, :integer
  end

  def self.down
    remove_column :notifications, :initiator_id
  end
end
