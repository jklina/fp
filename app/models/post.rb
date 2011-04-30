class Post < ActiveRecord::Base
  include Twitter::Extractor
  attr_accessible :content

  belongs_to :topic
  belongs_to :forum
  belongs_to :user
  has_many :notifications, :as => :notifiable
  
  validates_presence_of :content
  
  before_save   :send_notifications
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
  
  def send_notifications
    usernames = extract_mentioned_screen_names(content)
    usernames.uniq.each do |username|
      notification = Notification.new(:initiator => user, :description => "You were tagged by #{user.username} in a forum post.")
      notification.user = User.find_by_username(username)
      if notification.save!
        self.notifications << notification
      end
    end
  end
  
end
