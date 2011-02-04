class Post < ActiveRecord::Base
  attr_accessible :content

  belongs_to :topic
  belongs_to :forum
  belongs_to :user
  
  after_save :timestamp_topic
  
  validates_presence_of :content
  
  def content_html
    RedCloth.new(self.content).to_html.html_safe
  end
  
  protected
  
  def timestamp_topic
    self.topic.last_post_created_at = Time.now
    self.topic.save
  end
end
