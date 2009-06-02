class Category < ActiveRecord::Base
  has_many		:submissions, 		:dependent => :nullify
end
