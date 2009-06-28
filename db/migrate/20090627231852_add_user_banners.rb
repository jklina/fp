class AddUserBanners < ActiveRecord::Migration
  include PaperclipMigrations

  def self.up
    add_paperclip_fields :users, :banner
  end

  def self.down
    remove_column :users, :banner_file_name
    remove_column :users, :banner_content_type
    remove_column :users, :banner_file_size
    remove_column :users, :banner_updated_at
  end
end
