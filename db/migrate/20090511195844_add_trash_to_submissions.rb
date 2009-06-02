class AddTrashToSubmissions < ActiveRecord::Migration
  def self.up
    add_column :submissions, :owner_trash, :bool
	add_column :submissions, :moderator_trash, :bool
  end

  def self.down
	remove_column :submissions, :owner_trash
	remove_column :submissions, :moderator_trash
  end
end
