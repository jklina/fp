require 'test_helper'

class FeaturingTest < ActiveSupport::TestCase
  context "The Featuring class" do
    should     allow_mass_assignment_of(:feature)
    should     allow_mass_assignment_of(:feature_id)
    should     allow_mass_assignment_of(:submission)
    should     allow_mass_assignment_of(:submission_id)
    should_not allow_mass_assignment_of(:id)
    should_not allow_mass_assignment_of(:created_at)
    should_not allow_mass_assignment_of(:updated_at)

    should belong_to(:feature)
    should belong_to(:submission)
  end

  context "A Featuring instance" do
    setup do
      @submission = Factory(:submission)
      @featuring  = Factory.build(:featuring, :submission => @submission)
    end

    should "set its submission's featured_at after create" do
      assert @featuring.new_record?
      assert @featuring.save
      @submission.reload
      assert_equal @featuring.created_at, @submission.featured_at
    end

    should "nilify its submission's featured_at after destroy" do
      assert @featuring.destroy
      @submission.reload
      assert_nil @submission.featured_at
    end
  end
end
