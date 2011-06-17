class AddDefaultValueToReadInNotifications < ActiveRecord::Migration
  def self.up
    change_column_default(:notifications, :read, false)
  end

  def self.down
    change_column_default(:notifications, :read, nil)
  end
end
