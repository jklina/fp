class AddLastPostCreatedAtToTopic < ActiveRecord::Migration
  def self.up
    add_column :topics, :last_post_created_at, :timestamp
  end

  def self.down
    remove_column :topics, :last_post_created_at
  end
end
