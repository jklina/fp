class RatingController < ApplicationController

  require "statistics/statistics2"

  before_filter :request_authentication, :find_user, :find_submission
  
  def create
	
    @rating = Rating.new(params[:rating])
	@rating.admin = @user.is_authorative_user?
	@rating.user = @user
	@rating.submission = @submission
	
	#Add rating
    if @rating.save
	  update_rating_stats(@submission, @submission.ratings)
	  for user in @submission.users
	    user.received_ratings << @rating
		update_rating_stats(user, user.received_ratings)
	  end
      flash[:notice] = 'Your rating has been posted.'
      redirect_to (:back)
    else
      flash[:warning] = 'Unable to save your rating. Please make sure you have entered something.'
	  redirect_to (:back)
    end
  end
	
  def update
	
	@rating = @submission.ratings.find_by_user_id(@user)
	
	#Add rating
    if @rating.update_attributes(params[:rating])
	  update_rating_stats(@submission, @submission.ratings)
	  for user in @submission.users
		update_rating_stats(user, user.received_ratings)
	  end
      flash[:notice] = 'Your rating has been posted.'
      redirect_to (:back)
    else
      flash[:warning] = 'Unable to save your rating. Please make sure you have entered something.'
	  redirect_to (:back)
    end
  end
	
  protected
  
    def find_user
	  @user = User.find_by_id(session[:user])
	end
	
	def find_submission
	 @submission = Submission.find_by_id(params[:id]) 
	end
	
	def update_rating_stats(ratings_parent, ratings)
	  #Get ratings stats
	  @counts = ratings.count(:group => :admin)
	  @averages = ratings.average(:rating, :group => :admin)
	  #Not database independent. Have to think of a way to do that.
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
