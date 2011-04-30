class Comment < ActiveRecord::Base
  include Twitter::Extractor
  attr_accessible :body, :user, :commentable
  
  before_save :send_notifications
  
  belongs_to :user
  belongs_to :commentable, :polymorphic => true
  has_many :notifications, :as => :notifiable

  validates_presence_of :body

  def body_html
    RedCloth.new(self.body).to_html.html_safe
  end
  
  private
  
  def send_notifications
    usernames = extract_mentioned_screen_names(body)
    usernames.uniq.each do |username|
      notification = Notification.new(:initiator => user, :description => "You were tagged by #{user.username} in a comment.")
      notification.user = User.find_by_username(username)
      if notification.save!
        self.notifications << notification
      end
    end
  end
  
end
