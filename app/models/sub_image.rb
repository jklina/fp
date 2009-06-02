class SubImage < ActiveRecord::Base
  belongs_to :submission
  
  has_attachment  :storage => :file_system,
				  :content_type => :image,
                  :max_size => 30.megabytes,
                  :thumbnails => { :thumb => '806x507>', :tiny => '194x122>' },
                  :processor => 'Rmagick'

  validates_as_attachment
end
