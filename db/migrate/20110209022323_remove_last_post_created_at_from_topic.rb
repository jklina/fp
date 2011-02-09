class RemoveLastPostCreatedAtFromTopic < ActiveRecord::Migration
  def self.up
    remove_column :topics, :last_post_created_at
  end

  def self.down
    add_column :topics, :last_post_created_at, :datetime
  end
end
