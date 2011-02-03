require 'test_helper'

class ForumTest < ActiveSupport::TestCase
  context "The Forum class" do
    should     allow_mass_assignment_of(:title)
    should     allow_mass_assignment_of(:description)
    should     allow_mass_assignment_of(:weight)
    should     allow_mass_assignment_of(:forum_group_id)
    should_not allow_mass_assignment_of(:id)
    should_not allow_mass_assignment_of(:created_at)
    should_not allow_mass_assignment_of(:updated_at)

    should belong_to(:forum_group)
    should have_many(:topics).dependent(:destroy)
    should have_many(:posts).dependent(:destroy)

    should validate_presence_of(:title)
    should validate_presence_of(:weight)

    should ensure_inclusion_of(:weight).in_range(-100..100)
             .with_low_message("must be between -100 and 100, inclusive.")
             .with_high_message("must be between -100 and 100, inclusive.")
  end
end
