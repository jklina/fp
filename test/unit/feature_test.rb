require 'test_helper'

class FeatureTest < ActiveSupport::TestCase
  context "The Feature class" do
    should     allow_mass_assignment_of(:title)
    should     allow_mass_assignment_of(:comment)
    should     allow_mass_assignment_of(:user)
    should     allow_mass_assignment_of(:preview)
    should_not allow_mass_assignment_of(:user_id)
    should_not allow_mass_assignment_of(:preview_file_name)
    should_not allow_mass_assignment_of(:preview_content_type)
    should_not allow_mass_assignment_of(:preview_file_size)
    should_not allow_mass_assignment_of(:preview_updated_at)
    should_not allow_mass_assignment_of(:created_at)
    should_not allow_mass_assignment_of(:updated_at)

    should belong_to(:user)
    should have_many(:featurings)
    should have_many(:submissions).through(:featurings)

    should validate_presence_of(:title)
    should validate_presence_of(:comment)
  end

  context "A Feature instance" do
    setup do
      @feature = Factory(:feature)
    end

    should "produce HTML when calling comment_html" do
      assert_equal RedCloth.new(@feature.comment).to_html, @feature.comment_html
    end
  end
end
