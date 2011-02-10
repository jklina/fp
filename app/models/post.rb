class Post < ActiveRecord::Base
  attr_accessible :content

  belongs_to :topic
  belongs_to :forum
  belongs_to :user
  
  validates_presence_of :content
  
  #So the topic gets pushed to the top without any replies
  after_create :set_last_post_info
  
  def content_html
    RedCloth.new(self.content).to_html.html_safe
  end
  
  protected
  
  def set_last_post_info
    self.topic.last_poster = user
    self.topic.last_post_at = Time.now
    self.topic.save
  end
  
end
