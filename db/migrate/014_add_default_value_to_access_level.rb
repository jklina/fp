class AddDefaultValueToAccessLevel < ActiveRecord::Migration
  def self.up
    change_column	:users, 	:access_level,		:integer, 		:default => 1
  end

  def self.down
    change_column	:users, 	:access_level,		:integer
  end
end
