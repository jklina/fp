class TweakOwnerAndModeratorTrashColumns < ActiveRecord::Migration
  def self.up
    rename_column :submissions, :owner_trash, :trashed
    rename_column :submissions, :moderator_trash, :moderated

    change_column :submissions, :trashed, :boolean, :default => false
    change_column :submissions, :moderated, :boolean, :default => false
  end

  def self.down
    rename_column :submissions, :trashed, :owner_trash
    rename_column :submissions, :moderated, :moderator_trash
  end
end
