class StaticPage < ActiveRecord::Base
  attr_accessible :title, :slug, :body

  before_validation  :generate_or_sanitize_slug
 
  validates_presence_of :title, :slug, :body
  validates_uniqueness_of :title, :case_sensitive => false
  validates_uniqueness_of :slug

  def to_param
    slug
  end

  def body_html
    RedCloth.new(body).to_html.html_safe
  end

  def published_at
    created_at.strftime("%B %d, %Y")
  end

  protected

  def generate_or_sanitize_slug
    if slug.blank?
	    self.slug = title ? title.parameterize : nil
	  else
	    self.slug = slug.parameterize
	  end
  end
end
