class RenameFeaturedTables < ActiveRecord::Migration
  def self.up
    rename_column :featured_associations, :featured_id, :feature_id
    rename_column :featured_images, :featured_id, :feature_id

    rename_table :featured_associations, :featurings
    rename_table :featured_images, :feature_images
    rename_table :featureds, :features

    File.rename("#{RAILS_ROOT}/public/featured_images", "#{RAILS_ROOT}/public/feature_images")
  end

  def self.down
    rename_column :featurings, :feature_id, :featured_id
    rename_column :feature_images, :feature_id, :featured_id

    rename_table :featurings, :featured_associations
    rename_table :feature_images, :featured_images
    rename_table :features, :featureds

    File.rename("#{RAILS_ROOT}/public/feature_images", "#{RAILS_ROOT}/public/featured_images")
  end
end
