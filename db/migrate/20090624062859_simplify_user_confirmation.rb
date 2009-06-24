class SimplifyUserConfirmation < ActiveRecord::Migration
  def self.up
    remove_column :users, :email_confirmation_salt
    rename_column :users, :email_confirmation_hash, :confirmation_token

    add_column :users, :confirmed, :boolean, :default => false
    User.reset_column_information

    say_with_time "Converting account confirmation to boolean values..." do
      User.find(:all).each do |u|
        u.update_attribute(:confirmed, u.email_confirmation > 0)
      end
    end

    remove_column :users, :email_confirmation
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration, "Can't restore deleted data."
  end
end
