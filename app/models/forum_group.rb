# == Schema Information
# Schema version: 20100906213500
#
# Table name: forum_groups
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  weight     :integer         default(0), not null
#

class ForumGroup < ActiveRecord::Base
  attr_accessible :title, :weight

  has_many :forums, :dependent => :nullify, :order => 'weight ASC'

  validates_presence_of :title, :weight
  validates_inclusion_of :weight, :in => -100..100, :message => "must be between -100 and 100, inclusive."
end
