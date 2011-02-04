class Category < ActiveRecord::Base
  attr_accessible :title, :description

  has_many :submissions, :dependent => :nullify

  validates_presence_of :title

  def description_html
    RedCloth.new(description || "").to_html.html_safe
  end
end
