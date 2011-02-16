require 'test_helper'

class ReviewTest < ActiveSupport::TestCase
  context "The Review class" do
    should     allow_mass_assignment_of(:comment)
    should     allow_mass_assignment_of(:rating)
    should_not allow_mass_assignment_of(:by_administrator)
    should_not allow_mass_assignment_of(:submission)
    should_not allow_mass_assignment_of(:submission_id)
    should_not allow_mass_assignment_of(:user)
    should_not allow_mass_assignment_of(:user_id)
    should_not allow_mass_assignment_of(:created_at)
    should_not allow_mass_assignment_of(:updated_at)
  end

  context "A Review instance" do
    context "that hasn't been saved" do
      setup do
        @submission = Factory(:submission)
        @review     = Factory.build(:review, :submission => @submission)
      end

      should "produce an appropriate response when calling unrated?" do
        @review.rating = nil
        assert @review.unrated?
        @review.rating = 100
        assert !@review.unrated?
      end

      should "produce an appropriate response when calling uncommented?" do
        @review.comment = nil
        assert @review.uncommented?
        @review.comment = Faker::Lorem.sentences.join(" ")
        assert !@review.uncommented?
      end

      should "require a comment if rating is blank" do
        @review.rating = nil
        assert @review.rating.blank?
        assert @review.errors[:comment]
      end

      should "require a rating if comment is blank" do
        @review.comment = nil
        assert @review.comment.blank?
        assert @review.errors[:rating]
      end

      should "ensure rating is between 1 and 100 inclusive" do
        @review.rating = 0
        assert @review.errors[:rating]
        @review.rating = 101
        assert @review.errors[:rating]
        @review.rating = 1
        assert @review.valid?
        @review.rating = 100
        assert @review.valid?
      end

      should "change its submission's admin statistics after saving" do
        old_admin_rating             = @submission.admin_rating
        old_admin_rating_lower_bound = @submission.admin_rating_lower_bound
        old_admin_rating_upper_bound = @submission.admin_rating_upper_bound

        # Same as above.
        3.times do
          review = Factory(:review, :submission => @submission)
          review.by_administrator = true
          assert review.by_administrator
          review.save!
          @submission.reload
        end

        assert_not_equal old_admin_rating,             @submission.admin_rating
        assert_not_equal old_admin_rating_lower_bound, @submission.admin_rating_lower_bound
        assert_not_equal old_admin_rating_upper_bound, @submission.admin_rating_upper_bound
      end

      should "change its submission's user statistics after saving if it's a user review" do
        old_user_rating             = @submission.user_rating
        old_user_rating_lower_bound = @submission.user_rating_lower_bound
        old_user_rating_upper_bound = @submission.user_rating_upper_bound

        # Need at least three reviews to produce values for the lower and upper bounds.
        3.times do
          review = Factory(:review, :submission => @submission)
          assert !review.by_administrator
          review.save!
          @submission.reload
        end

        assert_not_equal old_user_rating,             @submission.user_rating
        assert_not_equal old_user_rating_lower_bound, @submission.user_rating_lower_bound
        assert_not_equal old_user_rating_upper_bound, @submission.user_rating_upper_bound
      end
      
      should "only show reviews of unmoderated submissions when the unmoderated submission scope is called" do
        review = Factory(:review, :submission => @submission)
        review.save!
        assert_not_equal @submission.moderated, true
        assert_equal Review.unmoderated_submission.find(review), review
        @submission.moderated = true
        @submission.save!
        assert_raises(ActiveRecord::RecordNotFound) do
          Review.unmoderated_submission.find(review)
        end
      end
    end

    context "that's been saved" do
      setup do
        @review = Factory(:review)
      end

      should "produce HTML when calling comment_html if comment is present" do
        @review.comment = Faker::Lorem.sentences.join(" ")
        assert @review.comment.present?
        assert_equal RedCloth.new(@review.comment).to_html, @review.comment_html
      end

      should "produce an empty string when calling comment_html if comment is blank" do
        @review.comment = nil
        assert @review.comment.blank?
        assert_equal "", @review.comment_html
      end
    end
  end
end
