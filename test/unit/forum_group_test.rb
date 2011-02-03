require 'test_helper'

class ForumGroupTest < ActiveSupport::TestCase
  context "The ForumGroup class" do
    should     allow_mass_assignment_of(:title)
    should     allow_mass_assignment_of(:weight)
    should_not allow_mass_assignment_of(:id)
    should_not allow_mass_assignment_of(:created_at)
    should_not allow_mass_assignment_of(:updated_at)

    should have_many(:forums)

    should validate_presence_of(:title)
    should validate_presence_of(:weight)

    should ensure_inclusion_of(:weight).in_range(-100..100)
             .with_low_message("must be between -100 and 100, inclusive.")
             .with_high_message("must be between -100 and 100, inclusive.")
  end
end
