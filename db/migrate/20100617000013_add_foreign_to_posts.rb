class AddForeignToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :thread_id, :integer
  end

  def self.down
    remove_column :posts, :thread_id
  end
end
