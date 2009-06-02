class Submission < ActiveRecord::Base
  has_many		:featured_associations
  has_many		:featureds, 	:through => 	:featured_associations
  has_many		:submission_associations
  has_many		:users, 		:through => 	:submission_associations
  has_many		:comments
  has_many		:ratings
  has_many 		:raters,		:through =>		:ratings, 	:source => :user
  has_one 		:sub_image, 	:dependent => 	:destroy
  has_one 		:sub_file, 		:dependent => 	:destroy
  belongs_to	:category
  has_many		:featured_associations
  has_many		:featureds, 	:through => 	:featured_associations

  validates_presence_of :title, :description, :sub_image
  validates_associated :sub_image
  
  #def find_not_trashed
  #  return find(:all, :conditions =>  {'approved is true'})
  #end
  
  def trashed?
    return (self.owner_trash == true || self.moderator_trash == true)
  end

  
end
