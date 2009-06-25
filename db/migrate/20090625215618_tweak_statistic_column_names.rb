class TweakStatisticColumnNames < ActiveRecord::Migration
  def self.up
    rename_column :submissions, :average_rating,                   :user_rating
    rename_column :submissions, :average_rating_lower_bound,       :user_rating_lower_bound
    rename_column :submissions, :average_rating_upper_bound,       :user_rating_upper_bound
    rename_column :submissions, :average_admin_rating,             :admin_rating
    rename_column :submissions, :average_admin_rating_lower_bound, :admin_rating_lower_bound
    rename_column :submissions, :average_admin_rating_upper_bound, :admin_rating_upper_bound

    rename_column :users, :average_rating,                   :user_rating
    rename_column :users, :average_rating_lower_bound,       :user_rating_lower_bound
    rename_column :users, :average_rating_upper_bound,       :user_rating_upper_bound
    rename_column :users, :average_admin_rating,             :admin_rating
    rename_column :users, :average_admin_rating_lower_bound, :admin_rating_lower_bound
    rename_column :users, :average_admin_rating_upper_bound, :admin_rating_upper_bound
  end

  def self.down
    rename_column :submissions, :user_rating,              :average_rating
    rename_column :submissions, :user_rating_lower_bound,  :average_rating_lower_bound
    rename_column :submissions, :user_rating_upper_bound,  :average_rating_upper_bound
    rename_column :submissions, :admin_rating,             :average_admin_rating
    rename_column :submissions, :admin_rating_lower_bound, :average_admin_rating_lower_bound
    rename_column :submissions, :admin_rating_upper_bound, :average_admin_rating_upper_bound

    rename_column :users, :user_rating,              :average_rating
    rename_column :users, :user_rating_lower_bound,  :average_rating_lower_bound
    rename_column :users, :user_rating_upper_bound,  :average_rating_upper_bound
    rename_column :users, :admin_rating,             :average_admin_rating
    rename_column :users, :admin_rating_lower_bound, :average_admin_rating_lower_bound
    rename_column :users, :admin_rating_upper_bound, :average_admin_rating_upper_bound
  end
end
