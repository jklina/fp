require 'test_helper'

class SubmissionTest < ActiveSupport::TestCase
  context "The Submission class" do
    should     allow_mass_assignment_of(:title)
    should     allow_mass_assignment_of(:description)
    should     allow_mass_assignment_of(:category_id)
    should     allow_mass_assignment_of(:preview)
    should     allow_mass_assignment_of(:file)

    should_not allow_mass_assignment_of(:id)
    should_not allow_mass_assignment_of(:created_at)
    should_not allow_mass_assignment_of(:updated_at)
    should_not allow_mass_assignment_of(:user_rating)
    should_not allow_mass_assignment_of(:user_rating_lower_bound)
    should_not allow_mass_assignment_of(:user_rating_upper_bound)
    should_not allow_mass_assignment_of(:admin_rating)
    should_not allow_mass_assignment_of(:admin_rating_lower_bound)
    should_not allow_mass_assignment_of(:admin_rating_upper_bound)
    should_not allow_mass_assignment_of(:trashed)
    should_not allow_mass_assignment_of(:moderated)
    should_not allow_mass_assignment_of(:views)
    should_not allow_mass_assignment_of(:downloads)
    should_not allow_mass_assignment_of(:preview_file_name)
    should_not allow_mass_assignment_of(:preview_content_type)
    should_not allow_mass_assignment_of(:preview_file_size)
    should_not allow_mass_assignment_of(:preview_updated_at)
    should_not allow_mass_assignment_of(:file_file_name)
    should_not allow_mass_assignment_of(:file_content_type)
    should_not allow_mass_assignment_of(:file_file_size)
    should_not allow_mass_assignment_of(:file_updated_at)
    should_not allow_mass_assignment_of(:featured_at)

    should belong_to(:category)
    should have_many(:authorships).dependent(:destroy)
    should have_many(:users).through(:authorships)
    should have_many(:reviews).dependent(:delete_all)
    should have_many(:featurings)
    should have_many(:features).through(:featurings)

    should validate_presence_of(:title)
    should validate_presence_of(:description)
  end

  context "A Submission instance" do
    setup do
      @user       = Factory(:user)
      @submission = Factory(:submission)
    end

    should "produce HTML when calling description_html" do
      assert_equal RedCloth.new(@submission.description).to_html, @submission.description_html
    end

    should "use its preview's path as the download_path when no file is present" do
      assert_nil   @submission.file.path
      assert_equal @submission.preview.path, @submission.download_path
    end

    should "use its file's path as the download_path when a file is present" do
      @submission.file = File.new(File.join(Rails.root, "test", "fixtures", "files", "submission.png"))
      assert_equal @submission.file.path, @submission.download_path
    end

    should "return true when calling authored_by? with a user who is a submission author" do
      assert @submission.authored_by?(@submission.users.first)
    end

    should "return false when calling authored_by? with a user who isn't a submission author" do
      assert !@submission.authored_by?(@user)
    end

    should "set trashed to true when calling trash" do
      @submission.trash
      @submission.reload
      assert @submission.trashed
    end

    should "set trashed to false when calling untrash" do
      @submission.untrash
      @submission.reload
      assert !@submission.trashed
    end

    should "set trashed to true when calling moderate" do
      @submission.moderate
      @submission.reload
      assert @submission.moderated
    end

    should "set trashed to false when calling unmoderate" do
      @submission.unmoderate
      @submission.reload
      assert !@submission.moderated
    end

    should "provide produce admin ratings on submissions when calling admin_ratings" do
      pending "Update this test after reviews get their test suite."
    end

    should "provide produce user ratings on submissions when calling admin_ratings" do
      pending "Update this test after reviews get their test suite."
    end

    should "update statistics when calling update_statistics!" do
      pending "Update this test after reviews get their test suite."
    end

    should "update its users' statistics when calling update_users_statistics!" do
      pending "Update this test after reviews get their test suite."
    end
  end
end
