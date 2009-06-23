class FeaturedImage < ActiveRecord::Base
  belongs_to :featured
  
  has_attachment  :storage => :file_system,
                  :content_type => :image,
                  :max_size => 30.megabytes,
                  :resize_to => '806x218',
                  :thumbnails => { :tiny => '194x122>' },
                  :processor => 'Rmagick'

  validates_as_attachment
end
