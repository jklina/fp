require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  context "The Comment class" do
    should     allow_mass_assignment_of(:body)
    should     allow_mass_assignment_of(:user)
    should     allow_mass_assignment_of(:commentable)
    should_not allow_mass_assignment_of(:id)
    should_not allow_mass_assignment_of(:commentable_type)
    should_not allow_mass_assignment_of(:commentable_id)
    should_not allow_mass_assignment_of(:created_at)
    should_not allow_mass_assignment_of(:updated_at)

    should belong_to(:user)
    should belong_to(:commentable)

    should validate_presence_of(:body)
  end

  context "A Comment instance" do
    setup do
      @comment = Factory(:comment)
    end

    should "produce HTML when calling body_html" do
      assert_equal RedCloth.new(@comment.body).to_html, @comment.body_html
    end
  end
end
