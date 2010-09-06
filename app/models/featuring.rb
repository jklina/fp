# == Schema Information
# Schema version: 20100906145157
#
# Table name: featurings
#
#  id            :integer         not null, primary key
#  submission_id :integer
#  feature_id    :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class Featuring < ActiveRecord::Base
  belongs_to :feature
  belongs_to :submission

  after_create :set_submission_featured_at!
  after_destroy :unset_submission_featured_at!

  protected

  def set_submission_featured_at!
    self.submission.update_attributes!(:featured_at => self.created_at)
  end

  def unset_submission_featured_at!
    self.submission.update_attributes!(:featured_at => nil)
  end
end
