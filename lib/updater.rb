require "statistics2"
require "calculations"

class Updater
  def self.update_rating_stats(ratable, ratings)
	  #Get ratings stats
	  counts = ratings.count(:group => :admin)
	  averages = ratings.average(:rating, :group => :admin)
	  split_ratings = ratings.group_by { |r| r.admin }
	
	  #Get T-values for a 95% confidence interval
	  admintvalue = Statistics2.ptdist(counts[1] - 1, 0.05)
	  tvalue = Statistics2.ptdist(counts[0] - 1, 0.05)
	  
	  #Put results in instance variables
	  admin_rating_count = counts[1]
	  user_rating_count = counts[0]
	
	  admin_average = averages[1]
	  user_average = averages[0]
	
	  admin_std = Calculations.standard_deviation(split_ratings[1].map { |r| r.rating })
	  user_std = Calculations.standard_deviation(split_ratings[0].map { |r| r.rating })
	
	  #Put statistics into submission variables for easy access
	  if admin_rating_count > 0
	    ratable.average_admin_rating_lower_bound = admin_average + admintvalue * (admin_std / Math.sqrt(admin_rating_count))
	    ratable.average_admin_rating_upper_bound = admin_average - admintvalue * (admin_std / Math.sqrt(admin_rating_count))
	  end
	
	  if user_rating_count > 0
	    ratable.average_rating_lower_bound = user_average + tvalue * (user_std / Math.sqrt(user_rating_count))
	    ratable.average_rating_upper_bound = user_average - tvalue * (user_std / Math.sqrt(user_rating_count))
	  end

	  ratable.average_admin_rating = admin_average
	  ratable.average_rating = user_average
	  
	  ratable.save
	end
end
