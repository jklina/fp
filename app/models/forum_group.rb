class ForumGroup < ActiveRecord::Base
  attr_accessible :title, :weight

  has_many :forums, :dependent => :nullify, :order => 'weight ASC'

  validates_presence_of :title, :weight
  validates_inclusion_of :weight, :in => -100..100, :message => "must be between -100 and 100, inclusive."
end
