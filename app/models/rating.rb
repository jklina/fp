class Rating < ActiveRecord::Base
  attr_protected :admin

  belongs_to :user
  belongs_to :rated_user, :class_name => "User", :foreign_key => "rated_user_id"
  
  belongs_to :submission
  
  validates_uniqueness_of   :user_id, :scope => :submission_id
  validates_numericality_of :rating,  :only_integer => true
  validates_inclusion_of    :rating,  :in => 1..100
end
