# == Schema Information
# Schema version: 20100906145157
#
# Table name: submissions
#
#  id                       :integer         not null, primary key
#  title                    :string(255)
#  description              :text
#  category_id              :integer
#  created_at               :datetime
#  updated_at               :datetime
#  user_rating              :float
#  user_rating_lower_bound  :float
#  user_rating_upper_bound  :float
#  admin_rating             :float
#  admin_rating_lower_bound :float
#  admin_rating_upper_bound :float
#  trashed                  :boolean
#  moderated                :boolean
#  views                    :integer         default(0)
#  downloads                :integer         default(0)
#  preview_file_name        :string(255)
#  preview_content_type     :string(255)
#  preview_file_size        :integer
#  preview_updated_at       :datetime
#  file_file_name           :string(255)
#  file_content_type        :string(255)
#  file_file_size           :integer
#  file_updated_at          :datetime
#  featured_at              :datetime
#

require "calculations"

class Submission < ActiveRecord::Base
  has_many		:authorships, 	:dependent => :destroy
  has_many		:users,		:through =>   :authorships
  has_many    		:reviews,     	:dependent => :delete_all
  has_many		:featurings
  has_many		:features,    	:through => 	:featurings
  belongs_to		:category

  has_attached_file :preview,
                    :styles => { :large => "806x507>", :thumbnail => "194x122>" },
		    :convert_options => { :all => "-quality 100 -strip" },
                    :path => PAPERCLIP_ASSET_PATH,
                    :url => PAPERCLIP_ASSET_URL

  validates_attachment_presence     :preview
  validates_attachment_size         :preview, :less_than => 5.megabytes
  validates_attachment_content_type :preview, :content_type => PAPERCLIP_IMAGE

  has_attached_file :file,
                    :path => PAPERCLIP_ASSET_PATH,
                    :url => PAPERCLIP_ASSET_URL

  validates_attachment_size :file, :less_than => 30.megabytes

  validates_presence_of :title, :description

  after_destroy :update_users_statistics!

  def authored_by?(user)
    self.users.include?(user)
  end

  def download_path
    self.file.path ? self.file.path : self.preview.path
  end

  def trash
    self.update_attribute(:trashed, true)
  end

  def untrash
    self.update_attribute(:trashed, false)
  end

  def moderate
    self.update_attribute(:moderated, true)
  end

  def unmoderate
    self.update_attribute(:moderated, false)
  end

  def update_statistics!
    administrator_statistics = Calculations.statistics(self.admin_ratings)
    user_statistics = Calculations.statistics(self.user_ratings)

    attributes = {
      :admin_rating =>             administrator_statistics[:mean],
      :admin_rating_lower_bound => administrator_statistics[:lower_bound],
      :admin_rating_upper_bound => administrator_statistics[:upper_bound], 
      :user_rating =>              user_statistics[:mean],
      :user_rating_lower_bound =>  user_statistics[:lower_bound],
      :user_rating_upper_bound =>  user_statistics[:upper_bound]
    }

    self.update_attributes!(attributes)
    self.update_users_statistics!
  end

  def description_html
    self.description ? RedCloth.new(self.description).to_html : ""
  end

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
