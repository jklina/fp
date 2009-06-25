require "calculations"

class Submission < ActiveRecord::Base
  has_one 		:sub_image,   :dependent => :destroy
  has_one 		:sub_file, 	  :dependent => :destroy
  has_many		:authorships, :dependent => :destroy
  has_many		:users, 		  :through =>   :authorships
  has_many		:comments
  has_many		:ratings
  has_many 		:raters,		  :through =>		:ratings, :source => :user
  has_many		:featurings
  has_many		:features,    :through => 	:featurings
  has_many    :reviews,     :dependent => :delete_all
  belongs_to	:category

  validates_presence_of :title, :description, :sub_image
  validates_associated  :sub_image

  after_save :update_users_statistics!
  after_destroy :update_users_statistics!

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
    self.update_attribute(:owner_trash, true)
  end

  def untrash
    self.update_attribute(:owner_trash, false)
  end

  def moderate
    self.update_attribute(:moderator_trash, true)
  end

  def unmoderate
    self.update_attribute(:moderator_trash, false)
  end

  def update_statistics!
    administrator_statistics = Calculations.statistics(self.admin_ratings)
    user_statistics = Calculations.statistics(self.user_ratings)

    attributes = {
      :average_admin_rating =>             administrator_statistics[:mean],
      :average_admin_rating_lower_bound => administrator_statistics[:lower_bound],
      :average_admin_rating_upper_bound => administrator_statistics[:upper_bound], 
      :average_rating =>                   user_statistics[:mean],
      :average_rating_lower_bound =>       user_statistics[:lower_bound],
      :average_rating_upper_bound =>       user_statistics[:upper_bound]
    }

    self.update_attributes!(attributes)
  end

  protected

  def admin_ratings
    self.reviews.map { |r| r.rating if r.by_administrator }.compact
  end

  def user_ratings
    self.reviews.map { |r| r.rating unless r.by_administrator }.compact
  end

  def update_users_statistics!
    self.users.each { |u| u.update_statistics! }
  end
end
