class PurgeUserlessReviews < ActiveRecord::Migration
  def self.up
    ids = Review.find(:all).map { |r| r.id unless r.user }.compact
    Review.find(ids).each { |r| r.destroy }
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration, "Can't restore deleted data."
  end
end
