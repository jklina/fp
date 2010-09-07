# == Schema Information
# Schema version: 20100906213500
#
# Table name: forums
#
#  id             :integer         not null, primary key
#  title          :string(255)
#  description    :text
#  created_at     :datetime
#  updated_at     :datetime
#  forum_group_id :integer
#  weight         :integer         default(0), not null
#

class Forum < ActiveRecord::Base
  belongs_to :forum_group
  has_many :topics, :dependent => :destroy, :order => 'updated_at DESC'
  has_many :posts, :dependent => :destroy
  
  validates_presence_of :title, :weight
  validates_inclusion_of :weight, :in => -100..100, :message => "must be inbetween -100 and 100."
end
