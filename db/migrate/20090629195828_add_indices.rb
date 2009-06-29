class AddIndices < ActiveRecord::Migration
  def self.up
    add_index :submissions, [ :trashed, :moderated ]
    add_index :users, :username
    add_index :authorships, :submission_id
    add_index :authorships, :user_id
  end

  def self.down
    remove_index :authorships, :user_id
    remove_index :authorships, :submission_id
    remove_index :users, :username
    remove_index :submissions, [ :trashed, :moderated ]
  end
end
