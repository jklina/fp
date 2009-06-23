class Submission < ActiveRecord::Base
  has_one 		:sub_image, :dependent => :destroy
  has_one 		:sub_file, 	:dependent => :destroy
  has_many		:submission_associations
  has_many		:users, 		:through =>   :submission_associations
  has_many		:comments
  has_many		:ratings
  has_many 		:raters,		:through =>		:ratings, :source => :user
  has_many		:featured_associations
  has_many		:featureds, :through => 	:featured_associations
  belongs_to	:category

  validates_presence_of :title, :description, :sub_image
  validates_associated  :sub_image

  def authored_by?(user)
    self.users.include?(user)
  end

  def download_filename
    self.sub_file.nil? ? self.sub_image.full_filename : self.sub_file.full_filename
  end

  def trashed?
    self.owner_trash
  end

  def moderated?
    self.moderator_trash
  end

  def trash
    self.owner_trash = true
    self.save
  end

  def untrash
    self.owner_trash = false
    self.save
  end

  def moderate
    self.moderator_trash = true
    self.save
  end

  def unmoderate
    self.moderator_trash = false
    self.save
  end
end
