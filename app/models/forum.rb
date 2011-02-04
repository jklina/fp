class Forum < ActiveRecord::Base
  attr_accessible :title, :description, :weight, :forum_group_id

  belongs_to :forum_group
  has_many   :topics, :dependent => :destroy, :order => 'last_post_created_at DESC'
  has_many   :posts,  :dependent => :destroy
  
  validates_presence_of :title, :weight
  validates_inclusion_of :weight, :in => -100..100, :message => "must be between -100 and 100, inclusive."
end
