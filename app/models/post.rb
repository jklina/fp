# == Schema Information
# Schema version: 20100906145157
#
# Table name: posts
#
#  id         :integer         not null, primary key
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#  thread_id  :integer
#  forum_id   :integer
#  topic_id   :integer
#  user_id    :integer
#

class Post < ActiveRecord::Base
  belongs_to :topic
  belongs_to :forum
  belongs_to :user
  
  validates_presence_of :content
  
  def content_html
    if self.content
      RedCloth.new(self.content).to_html
    end
  end
end
