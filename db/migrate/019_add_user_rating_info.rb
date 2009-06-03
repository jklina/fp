class AddUserRatingInfo < ActiveRecord::Migration
  def self.up
    #add_column :users, :average_rating, :float
	#  add_column :users, :average_rating_lower_bound, :float
	#  add_column :users, :average_rating_upper_bound, :float
    #add_column :users, :average_admin_rating, :float
	#  add_column :users, :average_admin_rating_lower_bound, :float
	#  add_column :users, :average_admin_rating_upper_bound, :float
  end

  def self.down
	#  remove_column :users, :average_rating
	#  remove_column :users, :average_rating_lower_bound
	#  remove_column :users, :average_rating_upper_bound
	#  remove_column :users, :average_admin_rating
	#  remove_column :users, :average_admin_rating_lower_bound
	#  remove_column :users, :average_admin_rating_upper_bound
  end
end
