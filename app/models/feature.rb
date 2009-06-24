class Feature < ActiveRecord::Base
  has_many    :featurings
  has_many    :submissions, 		:through =>   :featurings
  has_one     :feature_image, 	:dependent => :destroy
  belongs_to  :user
  
  validates_presence_of :title, :comment, :feature_image
  validates_associated  :feature_image
end
