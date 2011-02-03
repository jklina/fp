# == Schema Information
# Schema version: 20100918195633
#
# Table name: users
#
#  id                       :integer         not null, primary key
#  name                     :string(255)
#  last_login_time          :datetime
#  location                 :string(255)
#  country                  :string(255)
#  email                    :string(255)
#  aim                      :string(255)
#  msn                      :string(255)
#  icq                      :string(255)
#  yahoo                    :string(255)
#  website                  :string(255)
#  current_projects         :text
#  access_level             :integer         default(1)
#  password_salt            :string(255)
#  password_hash            :string(255)
#  created_at               :datetime
#  updated_at               :datetime
#  confirmation_token       :string(255)
#  username                 :string(255)
#  user_rating              :float
#  user_rating_lower_bound  :float
#  user_rating_upper_bound  :float
#  admin_rating             :float
#  admin_rating_lower_bound :float
#  admin_rating_upper_bound :float
#  confirmed                :boolean
#  photo_file_name          :string(255)
#  photo_content_type       :string(255)
#  photo_file_size          :integer
#  photo_updated_at         :datetime
#  banner_file_name         :string(255)
#  banner_content_type      :string(255)
#  banner_file_size         :integer
#  banner_updated_at        :datetime
#  authentication_token     :string(255)
#  time_zone                :string(255)
#

require "digest/sha2"
require "calculations"

class User < ActiveRecord::Base
  class Role
    ADMINISTRATOR = 3
    MODERATOR = 2
    REGULAR = 1
  end

  has_many :authorships
  has_many :submissions, :through =>   :authorships
  has_many :reviews,     :dependent => :destroy
  has_many :features
  has_many :announcements
  has_many :topics
  has_many :posts
  has_many :remarks,     :class_name => "Comment", :dependent => :destroy
  has_many :comments,    :as => :commentable,      :dependent => :destroy

  has_attached_file :photo,
                    :styles => { :thumbnail => "194x122>", :avatar => "58x58#" },
		    :convert_options => { :all => "-quality 100 -strip" },
                    :path => PAPERCLIP_ASSET_PATH,
                    :url => PAPERCLIP_ASSET_URL,
                    :default_url => "/images/avatar.png"

  validates_attachment_size         :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => PAPERCLIP_IMAGE

  has_attached_file :banner,
                    :styles => { :large => "736x58#" },
					:convert_options => { :all => "-quality 100 -strip" },
                    :path => PAPERCLIP_ASSET_PATH,
                    :url => PAPERCLIP_ASSET_URL,
                    :default_url => "/images/banner.png"

  validates_attachment_size         :banner, :less_than => 5.megabytes
  validates_attachment_content_type :banner, :content_type => PAPERCLIP_IMAGE

  attr_accessor :password, :password_confirmation

  validates_presence_of     :username
  validates_presence_of     :password,              :if => :password_required_or_present?
  validates_presence_of     :password_confirmation, :if => :password_required_or_present?
  validates_length_of	      :password,				      :if => :password_required_or_present?, :minimum => 5
  validates_confirmation_of :password,              :if => :password_required_or_present?
  validates_uniqueness_of   :username,              :case_sensitive => false
  validates_uniqueness_of   :email,                 :case_sensitive => false
  validates_format_of       :email, 				        :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/

  before_create :generate_confirmation_token
  before_save :encrypt_password

  def self.authenticate(username, password)
    user = self.find_by_username(username)
    !user.nil? && (self.encrypt("#{user.password_salt}--#{password}") == user.password_hash) ? user : nil
  end
  
  def self.confirm(token)
    user = self.find_by_confirmation_token(token) if token
    user.update_attribute(:confirmed, true) if user
  end

  def self.encrypt(string)
    Digest::SHA256.hexdigest(string)
  end

  def update_statistics!
    administrator_statistics = Calculations.statistics(self.admin_ratings)
    user_statistics = Calculations.statistics(self.user_ratings)
    user_admin_average_statistics = Calculations.statistics(self.user_ratings + self.admin_ratings)

    attributes = {
      :admin_rating =>                administrator_statistics[:mean],
      :admin_rating_lower_bound =>    administrator_statistics[:lower_bound],
      :admin_rating_upper_bound =>    administrator_statistics[:upper_bound], 
      :user_rating =>                 user_statistics[:mean],
      :user_rating_lower_bound =>     user_statistics[:lower_bound],
      :user_rating_upper_bound =>     user_statistics[:upper_bound],
      :average_rating =>              user_admin_average_statistics[:mean],
      :average_rating_upper_bound =>  user_admin_average_statistics[:lower_bound],
      :average_rating_lower_bound =>  user_admin_average_statistics[:upper_bound]
    }

    self.update_attributes!(attributes)
  end

  def admin_ratings
    self.submissions.map { |s| s.reviews.map { |r| r.rating if r.by_administrator } }.flatten.compact
  end

  def user_ratings
    self.submissions.map { |s| s.reviews.map { |r| r.rating unless r.by_administrator } }.flatten.compact
  end

  def remember
    token = self.class.encrypt("#{self.password_salt}--#{generate_salt}")
    self.update_attribute(:authentication_token, token)
  end

  def forget
    self.update_attribute(:authentication_token, nil)
  end
  
  def to_param
    username.parameterize
  end

  protected

  def password_required_or_present?
    self.password_hash.blank? || !password.blank?
  end

  def encrypt_password
    return if password.blank?
    self.password_salt = generate_salt if new_record?
    self.password_hash = self.class.encrypt("#{self.password_salt}--#{password}")
  end

  def generate_confirmation_token
    self.confirmation_token = self.class.encrypt("#{generate_salt}--#{email}")
  end

  def generate_salt
    self.class.encrypt("#{Time.now.to_s.split(//).sort_by {rand}.join}")
  end
end
