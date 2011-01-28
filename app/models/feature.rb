# == Schema Information
# Schema version: 20100906145157
#
# Table name: features
#
#  id                   :integer         not null, primary key
#  comment              :text
#  created_at           :datetime
#  updated_at           :datetime
#  user_id              :integer
#  title                :string(255)
#  preview_file_name    :string(255)
#  preview_content_type :string(255)
#  preview_file_size    :integer
#  preview_updated_at   :datetime
#

class Feature < ActiveRecord::Base
  has_many    :featurings
  has_many    :submissions,   :through =>   :featurings
  has_one     :feature_image, :dependent => :destroy
  belongs_to  :user

  has_attached_file :preview,
                    :styles => { :large => "806x218>", :thumbnail => "194x122>" },
					:convert_options => { :all => "-quality 100 -strip" },
                    :path => PAPERCLIP_ASSET_PATH,
                    :url => PAPERCLIP_ASSET_URL

  validates_attachment_presence     :preview
  validates_attachment_size         :preview, :less_than => 5.megabytes
  validates_attachment_content_type :preview, :content_type => PAPERCLIP_IMAGE

  validates_presence_of :title, :comment

  def comment_html
    self.comment ? RedCloth.new(self.comment).to_html.html_safe : ""
  end
end
