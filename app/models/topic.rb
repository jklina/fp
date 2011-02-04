class Topic < ActiveRecord::Base
  attr_accessible :title, :content

  belongs_to :forum
  belongs_to :user
  has_many   :posts, :dependent => :destroy

  validates_presence_of :title, :forum_id, :user_id
  
  def content_html
    RedCloth.new(content || "").to_html.html_safe
  end
  
end
