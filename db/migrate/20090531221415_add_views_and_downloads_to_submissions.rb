class AddViewsAndDownloadsToSubmissions < ActiveRecord::Migration
  def self.up
    #add_column :submissions, :views, :integer, :default => 0
	#add_column :submissions, :downloads, :integer, :default => 0
  end

  def self.down
    #remove_column :submissions, :views
	#remove_column :submissions, :downloads
  end
end
