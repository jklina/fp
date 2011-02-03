class AddAverageRatingToSubmissions < ActiveRecord::Migration
  def self.up
    add_column :submissions, :average_rating, :float
  end

  def self.down
    remove_column :submissions, :average_rating
  end
end
