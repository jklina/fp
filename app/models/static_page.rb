# == Schema Information
# Schema version: 20100906145157
#
# Table name: static_pages
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  slug       :string(255)
#  body       :string(255)
#  published  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class StaticPage < ActiveRecord::Base

  before_validation  :generate_and_slugify_if_necessary
 
  validates_presence_of :title, :slug, :body
  validates_uniqueness_of :title, :case_sensitive => false
  validates_uniqueness_of :slug
 
  #Generates slug either based off of a specified slug or the title. 
  def to_param
    "#{slug}"
  end
  
  def generate_and_slugify_if_necessary
    if slug.blank?
	  self.slug = title.parameterize
	else
	  self.slug = self.slug.parameterize
	end
  end
	
  def body_html
    RedCloth.new(self.body).to_html
  end

  def published_at
    self.created_at.strftime("%B %d, %Y")
  end

end
