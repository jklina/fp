class ForumGroup < ActiveRecord::Base
  has_many :forums, :dependent => :nullify
end
