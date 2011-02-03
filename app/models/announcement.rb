# == Schema Information
# Schema version: 20100906145157
#
# Table name: announcements
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  body       :text
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Announcement < ActiveRecord::Base
  attr_accessible :title, :body

  belongs_to :user
  has_many   :comments, :as => :commentable, :dependent => :destroy

  validates_presence_of :title, :body

  def body_html
    RedCloth.new(body).to_html.html_safe
  end

  def published_at
    created_at.strftime("%B %d, %Y")
  end
end
