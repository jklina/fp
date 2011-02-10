require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  context "The Topic class" do
    should     allow_mass_assignment_of(:title)
    should     allow_mass_assignment_of(:content)
    should_not allow_mass_assignment_of(:id)
    should_not allow_mass_assignment_of(:forum_id)
    should_not allow_mass_assignment_of(:user_id)
    should_not allow_mass_assignment_of(:view)
    should_not allow_mass_assignment_of(:last_poster_id)
    should_not allow_mass_assignment_of(:last_post_at)
    should_not allow_mass_assignment_of(:created_at)
    should_not allow_mass_assignment_of(:updated_at)

    should belong_to(:forum)
    should belong_to(:user)
    should belong_to(:last_poster)
    should have_many(:posts).dependent(:destroy)

    should validate_presence_of(:title)
    should validate_presence_of(:forum_id)
    should validate_presence_of(:user_id)
  end

  context "A Topic instance" do
    setup do
      @topic = Factory(:topic)
    end

    should "produce HTML when calling content_html if content is present" do
      assert @topic.content.present?
      assert_equal RedCloth.new(@topic.content).to_html, @topic.content_html
    end
    
    should "timestamp topic upon Topic creation" do
      assert_instance_of ActiveSupport::TimeWithZone, @topic.last_post_at
    end

    should "produce an empty string when calling body_html if content is blank" do
      @topic.content = nil
      assert @topic.content.blank?
      assert_equal "", @topic.content_html
    end
  end
end
