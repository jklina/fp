class RatingController < ApplicationController

  require "statistics/statistics2"
  require "statistics/statsupdater"

  before_filter :request_authentication, :find_user, :find_submission, :check_for_self_rater
  
  def create
	
    @rating = Rating.new(params[:rating])
	@rating.admin = @user.is_authorative_user?
	@rating.user = @user
	@rating.submission = @submission
	
	#Add rating
	
	if @rating.save
	  #I don't like this .new in these, but i'm leaving them in for now until i can think of something better.
	  StatsUpdater.new.update_rating_stats(@submission, @submission.ratings)
	  for user in @submission.users
		user.received_ratings << @rating
		StatsUpdater.new.update_rating_stats(user, user.received_ratings)
	  end
	  flash[:notice] = 'Your rating has been posted.'
	  redirect_to(request.env["HTTP_REFERER"])
	else
	  flash[:warning] = 'Unable to save your rating. Please make sure you have entered something.'
	  redirect_to(request.env["HTTP_REFERER"])
	end
  end
	
  def update
	
	@rating = @submission.ratings.find_by_user_id(@user)
	
	#Add rating
    if @rating.update_attributes(params[:rating])
	  #I don't like this .new in these, but i'm leaving them in for now until i can think of something better.
	  StatsUpdater.new.update_rating_stats(@submission, @submission.ratings)
	  for user in @submission.users
		StatsUpdater.new.update_rating_stats(user, user.received_ratings)
	  end
      flash[:notice] = 'Your rating has been posted.'
      redirect_to(request.env["HTTP_REFERER"])
    else
      flash[:warning] = 'Unable to save your rating. Please make sure you have entered something.'
	  redirect_to(request.env["HTTP_REFERER"])
    end
  end
	
  protected
  
  def check_for_self_rater
    if @submission.users.find_by_id(@user)
	  flash[:warning] = 'I can\'t go for that. No can do. '
	  redirect_to(request.env["HTTP_REFERER"])
	end
  end
  
  def find_user
    @user = User.find_by_id(session[:user])
  end
	
  def find_submission
    @submission = Submission.find_by_id(params[:id]) 
  end
end
