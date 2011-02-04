class Featuring < ActiveRecord::Base
  attr_accessible :feature, :feature_id, :submission, :submission_id

  belongs_to :feature
  belongs_to :submission

  after_create  :set_submission_featured_at!
  after_destroy :unset_submission_featured_at!

  protected

  def set_submission_featured_at!
    submission.featured_at = self.created_at
    submission.save!
  end

  def unset_submission_featured_at!
    submission.featured_at = nil
    submission.save!
  end
end
