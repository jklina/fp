class Category < ActiveRecord::Base
  has_many :submissions, :dependent => :nullify

  validates_presence_of :title

  def description_html
    self.description ? RedCloth.new(self.description).to_html : ""
  end
end
