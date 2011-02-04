require "calculations"

class Submission < ActiveRecord::Base
  attr_accessible :title, :description, :category_id, :preview, :file

  belongs_to  :category
  has_many    :authorships, :dependent => :destroy
  has_many    :users,       :through =>   :authorships
  has_many    :reviews,     :dependent => :delete_all
  has_many    :featurings
  has_many    :features,    :through => 	:featurings

  validates_presence_of :title, :description

  has_attached_file :preview,
                    :styles => { :large => "806x507>", :thumbnail => "194x122>" },
                    :convert_options => { :all => "-quality 100 -strip" },
                    :path => PAPERCLIP_ASSET_PATH,
                    :url  => PAPERCLIP_ASSET_URL

  validates_attachment_presence     :preview
  validates_attachment_size         :preview, :less_than => 5.megabytes
  validates_attachment_content_type :preview, :content_type => PAPERCLIP_IMAGE

  has_attached_file :file,
                    :path => PAPERCLIP_ASSET_PATH,
                    :url  => PAPERCLIP_ASSET_URL

  validates_attachment_size :file, :less_than => 30.megabytes

  after_destroy :update_users_statistics!

  def description_html
    RedCloth.new(self.description).to_html.html_safe
  end

  def download_path
    self.file.path ? self.file.path : self.preview.path
  end

  def authored_by?(user)
    self.users.include?(user)
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

  def admin_ratings
    self.reviews.map { |r| r.rating if r.by_administrator }.compact
  end

  def user_ratings
    self.reviews.map { |r| r.rating unless r.by_administrator }.compact
  end

  def update_statistics!
    administrator_statistics      = Calculations.statistics(self.admin_ratings)
    user_statistics               = Calculations.statistics(self.user_ratings)
    user_admin_average_statistics = Calculations.statistics(self.user_ratings + self.admin_ratings)

    self.admin_rating               = administrator_statistics[:mean]
    self.admin_rating_lower_bound   = administrator_statistics[:lower_bound]
    self.admin_rating_upper_bound   = administrator_statistics[:upper_bound]
    self.user_rating                = user_statistics[:mean]
    self.user_rating_lower_bound    = user_statistics[:lower_bound]
    self.user_rating_upper_bound    = user_statistics[:upper_bound]
    self.average_rating             = user_admin_average_statistics[:mean]
    self.average_rating_upper_bound = user_admin_average_statistics[:lower_bound]
    self.average_rating_lower_bound = user_admin_average_statistics[:upper_bound]

    self.save!
    self.update_users_statistics!
  end

  def update_users_statistics!
    self.users.each { |u| u.update_statistics! }
  end
end
