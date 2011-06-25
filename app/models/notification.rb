class Notification < ActiveRecord::Base
  attr_accessible :initiator, :description
  
  belongs_to :user
  belongs_to :notifiable, :polymorphic => true
  belongs_to :initiator, :class_name => "User", :foreign_key => 'initiator_id'
end
