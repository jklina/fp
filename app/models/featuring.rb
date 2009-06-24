class Featuring < ActiveRecord::Base
  belongs_to :feature
  belongs_to :submission
end
