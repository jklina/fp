class AddDisplayedEmailToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :displayed_email, :string
  end

  def self.down
    remove_column :users, :displayed_email
  end
end
