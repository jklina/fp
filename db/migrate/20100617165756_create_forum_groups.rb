class CreateForumGroups < ActiveRecord::Migration
  def self.up
    create_table :forum_groups do |t|
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :forum_groups
  end
end
