class AddPolymorphicColumnsToNotifications < ActiveRecord::Migration
  def self.up
    add_column :notifications, :notifiable_id, :integer
    add_column :notifications, :notifiable_type, :string
  end

  def self.down
    remove_column :notifications, :notifiable_type
    remove_column :notifications, :notifiable_id
  end
end
