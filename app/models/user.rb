require 'digest/sha2'

class User < ActiveRecord::Base
  has_many		:submission_associations
  has_many		:ratings
  has_many		:featureds
  has_many      :received_ratings,  :class_name => "Rating",  :foreign_key => "rated_user_id"
  has_many		:submissions, 		:through => 			:submission_associations
  has_many		:comments,   		:dependent => 			:destroy
  has_many		:users,				:through => 			:ratings
  has_one 		:user_image, 		:dependent => 			:destroy
  
  attr_accessor :password

  #attr_accessible :name, :password, :password_confirmation
  
  validates_presence_of     :name
  validates_presence_of     :username
  validates_presence_of     :password,              :if => :password_required_or_present?
  validates_presence_of     :password_confirmation, :if => :password_required_or_present?
  validates_length_of		:password,				:minimum => 5, 								:if => :password_required_or_present?
  validates_confirmation_of :password,              :if => :password_required_or_present?
  validates_uniqueness_of   :username,              :case_sensitive => false
  validates_uniqueness_of   :email,                 :case_sensitive => false
  validates_format_of       :email, 				:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/

  before_save :encrypt_password, :encrypt_email_hash
  

    

  def self.authenticate(username, password)
    user = self.find_by_username(username)
    !user.nil? && (self.encrypt("#{user.password_salt}--#{password}") == user.password_hash) ? user : nil
  end
  
   def self.confirm_email(hash)
    if user = self.find_by_email_confirmation_hash(hash)
      user.update_attribute(:email_confirmation, 1);
    end	  
	  
  end

  def self.encrypt(string)
    Digest::SHA256.hexdigest(string)
  end
  
  def is_authorative_user?
    self.access_level > User.registered_user ? true : false
  end
  
  def self.unregistered_user
    return 0
  end
  
  def self.registered_user
    return 1
  end
  
  def self.moderator
    return 2
  end
  
  def self.administrator
    return 3
  end

  protected

  def password_required_or_present?
    self.password_hash.blank? || !password.blank?
  end

  def encrypt_password
    return if password.blank?
    self.password_salt = generate_salt if new_record?
    self.password_hash = self.class.encrypt("#{self.password_salt}--#{password}") unless password.blank?
  end
  
   def encrypt_email_hash
    return if name.blank?
    self.email_confirmation_salt = generate_salt if new_record?
    self.email_confirmation_hash = self.class.encrypt("#{self.password_salt}--#{password}") unless password.blank?
  end

  def generate_salt
    self.class.encrypt("#{Time.now.to_s.split(//).sort_by {rand}.join}--#{self.name}")
  end
end
