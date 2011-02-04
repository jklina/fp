class Feature < ActiveRecord::Base
  attr_accessible :title, :comment, :user, :preview

  belongs_to :user
  has_many   :featurings
  has_many   :submissions, :through => :featurings

  validates_presence_of :title, :comment

  has_attached_file :preview,
                    :styles => { :large => "806x218>", :thumbnail => "194x122>" },
                    :convert_options => { :all => "-quality 100 -strip" },
                    :path => PAPERCLIP_ASSET_PATH,
                    :url => PAPERCLIP_ASSET_URL

  validates_attachment_presence     :preview
  validates_attachment_size         :preview, :less_than => 5.megabytes
  validates_attachment_content_type :preview, :content_type => PAPERCLIP_IMAGE

  def comment_html
     RedCloth.new(self.comment).to_html.html_safe
  end
end
