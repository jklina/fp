class FeaturedAssociation < ActiveRecord::Base
  belongs_to		:featured
  belongs_to		:submission
end
