class Topic < ActiveRecord::Base
  attr_accessible :title, :content

  belongs_to :forum
  belongs_to :user
  belongs_to :last_poster, :class_name => "User"
  has_many   :posts, :dependent => :destroy

  validates_presence_of :title, :forum_id, :user_id
  
  #So the topic gets pushed to the top without any replies
  after_create :set_last_post_info
  
  def content_html
    RedCloth.new(content || "").to_html.html_safe
  end
  
  protected
  
  def set_last_post_info
    self.last_poster = user
    self.last_post_at = Time.now
    self.save
  end
  
end
