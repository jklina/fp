class Post < ActiveRecord::Base
  attr_accessible :content

  belongs_to :topic
  belongs_to :forum
  belongs_to :user
  
  validates_presence_of :content
  
  def content_html
    RedCloth.new(self.content).to_html.html_safe
  end
  
end
