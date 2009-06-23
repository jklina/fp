class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :submission
  
  validates_presence_of :comment
end
