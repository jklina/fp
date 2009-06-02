class AddRecievedRating < ActiveRecord::Migration
  def self.up
    add_column :ratings, :rated_user_id, :int
  end

  def self.down
    remove_column :ratings, :rated_user_id
  end
end
