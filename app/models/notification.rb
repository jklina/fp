class Notification < ActiveRecord::Base
  attr_accessible
  
  belongs_to :user
  belongs_to :notifiable, :polymorphic => true
  has_one :initiator, :class_name => "User"
end
