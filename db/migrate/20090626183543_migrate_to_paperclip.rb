class MigrateToPaperclip < ActiveRecord::Migration
  include PaperclipMigrations

  def self.up
    add_paperclip_fields :users, :photo
    add_paperclip_fields :submissions, :preview
    add_paperclip_fields :submissions, :file
    add_paperclip_fields :features, :preview

    User.reset_column_information
    Submission.reset_column_information
    Feature.reset_column_information

    say_with_time "Migrating user photos to Paperclip..." do
      User.all.each { |u| populate_paperclip_from_attachment_fu(u, u.user_image, 'photo') if u.user_image }
    end

    say_with_time "Migrating submission previews and files to Paperclip..." do
      Submission.all.each do |s|
        populate_paperclip_from_attachment_fu(s, s.sub_image, 'preview') if s.sub_image
        populate_paperclip_from_attachment_fu(s, s.sub_file, 'file') if s.sub_file
      end
    end

    say_with_time "Migrating feature previews to Paperclip..." do
      Feature.all.each { |f| populate_paperclip_from_attachment_fu(f, f.feature_image, 'preview') if f.feature_image }
    end

    drop_table :user_images
    drop_table :sub_images
    drop_table :sub_files
    drop_table :feature_images

    say_with_time "Removing files and directories created by attachment_fu..." do
      FileUtils.rm_r File.join(RAILS_ROOT, "public", "user_images")
      FileUtils.rm_r File.join(RAILS_ROOT, "public", "sub_images")
      FileUtils.rm_r File.join(RAILS_ROOT, "public", "sub_files")
      FileUtils.rm_r File.join(RAILS_ROOT, "public", "feature_images")
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration, "Paperclip is awesome. attachment_fu is not."
  end
end
