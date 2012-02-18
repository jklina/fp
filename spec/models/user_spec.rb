require 'spec_helper'

describe User do
  it { should have_many(:submissions).through(:authorships) }
  it { should have_many(:reviews) }
  it { should have_many(:features) }
  it { should have_many(:announcements) }
  it { should have_many(:topics) }
  it { should have_many(:posts) }
  it { should have_many(:remarks) }
  it { should have_many(:comments) }
  it { should have_many(:notifications) }
  it { should have_many(:initiated_notifications) }

  it { should     allow_mass_assignment_of(:name) }
  it { should     allow_mass_assignment_of(:location) }
  it { should     allow_mass_assignment_of(:country) }
  it { should     allow_mass_assignment_of(:email) }
  it { should     allow_mass_assignment_of(:displayed_email) }
  it { should     allow_mass_assignment_of(:aim) }
  it { should     allow_mass_assignment_of(:msn) }
  it { should     allow_mass_assignment_of(:icq) }
  it { should     allow_mass_assignment_of(:yahoo) }
  it { should     allow_mass_assignment_of(:website) }
  it { should     allow_mass_assignment_of(:current_projects) }
  it { should     allow_mass_assignment_of(:time_zone) }
  it { should     allow_mass_assignment_of(:photo) }
  it { should     allow_mass_assignment_of(:banner) }
  it { should_not allow_mass_assignment_of(:username) }
  it { should_not allow_mass_assignment_of(:last_login_time) }
  it { should_not allow_mass_assignment_of(:access_level) }
  it { should_not allow_mass_assignment_of(:password_salt) }
  it { should_not allow_mass_assignment_of(:password_hash) }
  it { should_not allow_mass_assignment_of(:confirmation_token) }
  it { should_not allow_mass_assignment_of(:user_rating) }
  it { should_not allow_mass_assignment_of(:user_rating_lower_bound) }
  it { should_not allow_mass_assignment_of(:user_rating_upper_bound) }
  it { should_not allow_mass_assignment_of(:admin_rating) }
  it { should_not allow_mass_assignment_of(:admin_rating_lower_bound) }
  it { should_not allow_mass_assignment_of(:admin_rating_upper_bound) }
  it { should_not allow_mass_assignment_of(:confirmed) }
  it { should_not allow_mass_assignment_of(:authentication_token) }
  it { should_not allow_mass_assignment_of(:photo_file_name) }
  it { should_not allow_mass_assignment_of(:photo_content_type) }
  it { should_not allow_mass_assignment_of(:photo_file_size) }
  it { should_not allow_mass_assignment_of(:photo_updated_at) }
  it { should_not allow_mass_assignment_of(:banner_file_name) }
  it { should_not allow_mass_assignment_of(:banner_content_type) }
  it { should_not allow_mass_assignment_of(:banner_file_size) }
  it { should_not allow_mass_assignment_of(:banner_updated_at) }
  it { should_not allow_mass_assignment_of(:created_at) }
  it { should_not allow_mass_assignment_of(:updated_at) }

  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:password_confirmation) }

  it { should ensure_length_of(:password).is_at_least(5) }
  
  it { should validate_format_of(:username).
    with(/^[\w]{1,15}$/).
    with_message("username Please use a URL safe username.")
  }
  
  it { should validate_format_of(:email).
    with(/^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/)
  }

  it { 
    FactoryGirl.create(:normal_user)
    should validate_uniqueness_of(:email).case_insensitive
  }
  
  it { 
    FactoryGirl.create(:normal_user)
    should validate_uniqueness_of(:username).case_insensitive
  }
end
