class AddRatingInfo < ActiveRecord::Migration
  def self.up
    #add_column :submissions, :average_rating, :float
	#add_column :submissions, :average_rating_lower_bound, :float
	#add_column :submissions, :average_rating_upper_bound, :float
    #add_column :submissions, :average_admin_rating, :float
	#add_column :submissions, :average_admin_rating_lower_bound, :float
	#add_column :submissions, :average_admin_rating_upper_bound, :float
  end

  def self.down
	#remove_column :submissions, :average_rating
	#remove_column :submissions, :average_rating_lower_bound
	#remove_column :submissions, :average_rating_upper_bound
	#remove_column :submissions, :average_admin_rating
	#remove_column :submissions, :average_admin_rating_lower_bound
	#remove_column :submissions, :average_admin_rating_upper_bound
  end
end
