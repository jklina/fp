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
