# == Schema Information
# Schema version: 20100906145157
#
# Table name: categories
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

class Category < ActiveRecord::Base
  attr_accessible :title, :description

  has_many :submissions, :dependent => :nullify

  validates_presence_of :title

  def description_html
    RedCloth.new(description || "").to_html.html_safe
  end
end
