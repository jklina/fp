class RenameSubmissionAssociations < ActiveRecord::Migration
  def self.up
    rename_table :submission_associations, :authorships
  end

  def self.down
    rename_table :authorships, :submission_associations
  end
end
