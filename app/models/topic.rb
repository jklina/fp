# == Schema Information
# Schema version: 20100918195633
#
# Table name: topics
#
#  id                   :integer         not null, primary key
#  title                :string(255)
#  last_poster_id       :integer
#  last_post_at         :datetime
#  created_at           :datetime
#  updated_at           :datetime
#  forum_id             :integer
#  user_id              :integer
#  content              :text
#  view                 :integer         default(0), not null
#  last_post_created_at :datetime
#

class Topic < ActiveRecord::Base
  belongs_to :forum
  belongs_to :user
  has_many :posts, :dependent => :destroy
  
  def content_html
    if self.content
      RedCloth.new(self.content).to_html
    end
  end
  
end
