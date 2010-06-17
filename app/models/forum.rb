class Forum < ActiveRecord::Base
  belongs_to :forum_group
  has_many :topics, :dependent => :destroy
end
