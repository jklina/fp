class Featured < ActiveRecord::Base
  has_many    :featured_associations
  has_many    :submissions, 		:through =>   :featured_associations
  has_one     :featured_image, 	:dependent => :destroy
  belongs_to  :user
  
  validates_presence_of :title, :comment, :featured_image
  validates_associated  :featured_image
end
