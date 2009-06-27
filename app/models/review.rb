class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :submission

  attr_protected :by_administrator

  validates_presence_of     :comment,                           :if => :unrated?
  validates_presence_of     :rating,                            :if => :uncommented?
  validates_inclusion_of    :rating,  :in => 1..100,            :unless => :unrated?
  validates_numericality_of :rating,  :only_integer => true,    :unless => :unrated?
  validates_uniqueness_of   :user_id, :scope => :submission_id, :unless => :unrated?

  after_save :update_submission_statistics!
  after_destroy :update_submission_statistics!

  def unrated?
    self.rating.blank?
  end

  def uncommented?
    self.comment.blank?
  end

  def comment_html
    RedCloth.new(self.comment).to_html
  end

  protected

  def update_submission_statistics!
    self.submission.update_statistics!
  end
end
