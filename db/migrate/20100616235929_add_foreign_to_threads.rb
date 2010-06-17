class AddForeignToThreads < ActiveRecord::Migration
  def self.up
    add_column :threads, :forum_id, :integer
  end

  def self.down
    remove_column :threads, :forum_id
  end
end
