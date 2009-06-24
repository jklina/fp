require 'digest/sha2'

class User < ActiveRecord::Base
  class Role
    ADMINISTRATOR = 3
    MODERATOR = 2
    REGULAR = 1
  end

  has_many :authorships
  has_many :ratings
  has_many :features
  has_many :received_ratings, :class_name => "Rating", :foreign_key => "rated_user_id"
  has_many :submissions, :through =>   :authorships
  has_many :comments,    :dependent => :destroy
  has_many :users,			 :through =>   :ratings
  has_one  :user_image,  :dependent => :destroy

  attr_accessor :name, :password, :password_confirmation

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
