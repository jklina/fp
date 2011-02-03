class AddAverageRatingBoundsToSubmissions < ActiveRecord::Migration
  def self.up
    add_column :submissions, :average_rating_upper_bound, :float
    add_column :submissions, :average_rating_lower_bound, :float
  end

  def self.down
    remove_column :submissions, :average_rating_lower_bound
    remove_column :submissions, :average_rating_upper_bound
  end
end
