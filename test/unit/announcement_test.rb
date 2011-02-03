require 'test_helper'

class AnnouncementTest < ActiveSupport::TestCase
  context "The Announcement class" do
    should     allow_mass_assignment_of(:title)
    should     allow_mass_assignment_of(:body)
    should_not allow_mass_assignment_of(:id)
    should_not allow_mass_assignment_of(:created_at)
    should_not allow_mass_assignment_of(:updated_at)

    should belong_to(:user)
    should have_many(:comments).dependent(:destroy)

    should validate_presence_of(:title)
    should validate_presence_of(:body)
  end

  context "An Announcement instance" do
    setup do
      @announcement = Factory(:announcement)
    end

    should "produce HTML when calling body_html" do
      assert_equal RedCloth.new(@announcement.body).to_html, @announcement.body_html
    end

    should "produce a formatted date string when calling published_at" do
      assert_equal @announcement.created_at.strftime("%B %d, %Y"), @announcement.published_at
    end
  end
end
