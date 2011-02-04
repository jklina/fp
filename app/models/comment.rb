class Comment < ActiveRecord::Base
  attr_accessible :body, :user, :commentable

  belongs_to :user
  belongs_to :commentable, :polymorphic => true

  validates_presence_of :body

  def body_html
    RedCloth.new(self.body).to_html.html_safe
  end
end
