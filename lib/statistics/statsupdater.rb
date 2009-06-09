class StatsUpdater

#Given the ratings parent (in all cases I can think of this will be an instance of Submission or User), this will update the statistics in the parent's table.

	def update_rating_stats(ratings_parent, ratings)
	  #Get ratings stats
	  @counts = ratings.count(:group => :admin)
	  @averages = ratings.average(:rating, :group => :admin)
	  @stds = ratings.calculate(:std, :rating, :group => :admin)
	
	  #Get T-values for a 95% confidence interval
	  @adminTValue = Statistics2.ptdist(@counts[true].to_i-1, 0.05)
	  @tValue = Statistics2.ptdist(@counts[false].to_i-1, 0.05)
	  
	  #Put results in instance variables
	  @numOfAdminRatings = @counts[true].to_i
	  @numOfRatings = @counts[false].to_i
	
	  @adminAverage = @averages[true].to_f
	  @average = @averages[false].to_f
	
	  @adminSTD = @stds[true].to_f
	  @STD = @stds[false].to_f
	
	  #Put statistics into submission variables for easy access
	  unless(@numOfAdminRatings <= 0)
	    ratings_parent.average_admin_rating_lower_bound = @adminAverage + @adminTValue*(@adminSTD/Math.sqrt(@numOfAdminRatings))
	    ratings_parent.average_admin_rating_upper_bound = @adminAverage - @adminTValue*(@adminSTD/Math.sqrt(@numOfAdminRatings))
	  end
	
	  unless(@numOfRatings <= 0)
	    ratings_parent.average_rating_lower_bound = @average + @tValue*(@STD/Math.sqrt(@numOfRatings))
	    ratings_parent.average_rating_upper_bound = @average - @tValue*(@STD/Math.sqrt(@numOfRatings))
	  end
	  
	  ratings_parent.average_admin_rating = @adminAverage.to_f
	  ratings_parent.average_rating = @average.to_f
	  
	  ratings_parent.save
	end
end