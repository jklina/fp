class RenameThreadsToTopics < ActiveRecord::Migration
  def self.up
    rename_table :threads, :topics
  end

  def self.down
    rename_table :topics, :threads
  end
end
