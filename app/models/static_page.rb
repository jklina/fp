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
