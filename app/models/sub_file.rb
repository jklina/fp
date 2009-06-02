class SubFile < ActiveRecord::Base
  belongs_to :submission

  has_attachment  :storage => :file_system,
                  :max_size => 30.megabytes,
                  :thumbnails => { :thumb => '500x500>', :tiny => '200x200>' },
                  :processor => 'Rmagick'

end
