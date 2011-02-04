require 'test_helper'

class AuthorshipTest < ActiveSupport::TestCase
  context "The Authorship class" do
    should     allow_mass_assignment_of(:submission)
    should     allow_mass_assignment_of(:submission_id)
    should     allow_mass_assignment_of(:user)
    should     allow_mass_assignment_of(:user_id)
    should_not allow_mass_assignment_of(:id)
    should_not allow_mass_assignment_of(:created_at)
    should_not allow_mass_assignment_of(:updated_at)

    should belong_to(:submission)
    should belong_to(:user)
  end
end
