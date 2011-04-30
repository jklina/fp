class Review < ActiveRecord::Base
  include Twitter::Extractor
  attr_accessible :comment, :rating

  belongs_to :submission
  belongs_to :user
  has_many :notifications, :as => :notifiable

  validates_presence_of     :comment,                           :if => :unrated?
  validates_presence_of     :rating,                            :if => :uncommented?
  validates_inclusion_of    :rating,  :in => 1..100,            :unless => :unrated?
  validates_numericality_of :rating,  :only_integer => true,    :unless => :unrated?
  validates_uniqueness_of   :user_id, :scope => :submission_id, :unless => :unrated?

  before_save   :send_notifications
  after_save    :update_submission_statistics!
  after_destroy :update_submission_statistics!
  
  scope :public_submissions, Review.joins(:submission) & Submission.unmoderated.untrashed

  def comment_html
    RedCloth.new(comment || "").to_html.html_safe
  end

  def unrated?
    self.rating.blank?
  end

  def uncommented?
    self.comment.blank?
  end

  protected

  def update_submission_statistics!
    self.submission.update_statistics!
  end
  
  private
  
  def send_notifications
    usernames = extract_mentioned_screen_names(comment)
    usernames.uniq.each do |username|
      notification = Notification.new(:initiator => user, :description => "You were tagged by #{user.username} in a review.")
      notification.user = User.find_by_username(username)
      if notification.save!
        self.notifications << notification
      end
    end
  end
end
