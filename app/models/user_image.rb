class UserImage < ActiveRecord::Base
  belongs_to :user
  
  has_attachment  :storage => :file_system,
				  :content_type => :image,
                  :max_size => 30.megabytes,
                  :thumbnails => { :thumb => '603x207>', :tiny => '194x194>', :avatar => '54x54>' },
                  :processor => 'Rmagick'

  validates_as_attachment
end
