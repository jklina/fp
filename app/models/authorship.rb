# == Schema Information
# Schema version: 20100906145157
#
# Table name: authorships
#
#  id            :integer         not null, primary key
#  submission_id :integer
#  user_id       :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class Authorship < ActiveRecord::Base
  belongs_to :user
  belongs_to :submission

  after_create :update_user_statistics!
  after_destroy :update_user_statistics!

  protected

  def update_user_statistics!
    user.update_statistics!
  end
end
