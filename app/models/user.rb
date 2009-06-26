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

  has_attached_file :photo,
                    :styles => { :thumbnail => "194x122>", :avatar => "54x54#" },
                    :path => PAPERCLIP_ASSET_PATH,
                    :url => PAPERCLIP_ASSET_URL

  validates_attachment_size         :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => PAPERCLIP_IMAGE

  attr_accessor :password, :password_confirmation

  validates_presence_of     :name
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
    user = self.find_by_confirmation_token(token)
    user.update_attribute(:confirmed, true) unless user.nil?
    !user.nil?
  end

  def self.encrypt(string)
    Digest::SHA256.hexdigest(string)
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

  def admin_ratings
    self.submissions.map { |s| s.reviews.map { |r| r.rating if r.by_administrator } }.flatten.compact
  end

  def user_ratings
    self.submissions.map { |s| s.reviews.map { |r| r.rating unless r.by_administrator } }.flatten.compact
  end
end
