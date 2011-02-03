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
