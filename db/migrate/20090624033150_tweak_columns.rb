class TweakColumns < ActiveRecord::Migration
  def self.up
    rename_column :categories,  :created_on, :created_at
    rename_column :categories,  :updated_on, :updated_at

    rename_column :comments,    :created_on, :created_at

    rename_column :features,    :created_on, :created_at
    rename_column :features,    :updated_on, :updated_at

    rename_column :submissions, :created_on, :created_at
    rename_column :submissions, :updated_on, :updated_at

    change_column :submissions, :owner_trash, :boolean
    change_column :submissions, :moderator_trash, :boolean
  end

  def self.down
    rename_column :categories,  :created_at, :created_on
    rename_column :categories,  :updated_at, :updated_on

    rename_column :comments,    :created_at, :created_on

    rename_column :features,    :created_at, :created_on
    rename_column :features,    :updated_at, :updated_on

    rename_column :submissions, :created_at, :created_on
    rename_column :submissions, :updated_at, :updated_on
  end
end
