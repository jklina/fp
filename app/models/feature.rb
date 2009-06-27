class Feature < ActiveRecord::Base
  has_many    :featurings
  has_many    :submissions,   :through =>   :featurings
  has_one     :feature_image, :dependent => :destroy
  belongs_to  :user

  has_attached_file :preview,
                    :styles => { :large => "806x218>", :thumbnail => "194x122>" },
                    :path => PAPERCLIP_ASSET_PATH,
                    :url => PAPERCLIP_ASSET_URL

  validates_attachment_presence     :preview
  validates_attachment_size         :preview, :less_than => 5.megabytes
  validates_attachment_content_type :preview, :content_type => PAPERCLIP_IMAGE

  validates_presence_of :title, :comment

  def comment_html
    RedCloth.new(self.comment).to_html
  end
end
