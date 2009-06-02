class AddDefaultCategory < ActiveRecord::Migration
  def self.up
    Category.create(:title => 'Default', :description => 'This is the universally amazing super category')
  end

  def self.down
  end
end
