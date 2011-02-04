class Authorship < ActiveRecord::Base
  attr_accessible :user, :user_id, :submission, :submission_id

  belongs_to :user
  belongs_to :submission

  after_create  :update_user_statistics!
  after_destroy :update_user_statistics!

  protected

  def update_user_statistics!
    user.update_statistics!
  end
end
