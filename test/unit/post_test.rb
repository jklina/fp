require 'test_helper'

class PostTest < ActiveSupport::TestCase
  context "The Post class" do
    should     allow_mass_assignment_of(:content)
    should_not allow_mass_assignment_of(:id)
    should_not allow_mass_assignment_of(:forum_id)
    should_not allow_mass_assignment_of(:thread_id)
    should_not allow_mass_assignment_of(:topic_id)
    should_not allow_mass_assignment_of(:user_id)
    should_not allow_mass_assignment_of(:created_at)
    should_not allow_mass_assignment_of(:updated_at)

    should belong_to(:forum)
    should belong_to(:topic)
    should belong_to(:user)

    should validate_presence_of(:content)
  end

  context "A Post instance" do
    setup do
      @topic = Factory(:topic)
      @post  = Factory.build(:post, :topic => @topic)
    end

    should "update its topic's last_post_created_at when saving" do
      last_post_created_at = @topic.last_post_created_at
      assert @post.save
      @topic.reload
      assert_not_equal last_post_created_at, @topic.last_post_created_at
    end

    should "produce HTML when calling content_html" do
      assert_equal RedCloth.new(@post.content).to_html, @post.content_html
    end
  end
end
