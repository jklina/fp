class Announcement < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :title, :body

  def body_html
    RedCloth.new(self.body).to_html
  end

  def published_at
    self.created_at.strftime("%B %d, %Y")
  end
end
