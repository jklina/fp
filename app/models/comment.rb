class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, :polymorphic => true

  validates_presence_of :body

  def body_html
    RedCloth.new(self.body).to_html
  end
end
