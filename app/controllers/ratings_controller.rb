require "updater"

class RatingsController < ApplicationController
  before_filter :find_rating, :only => [ :destroy ]
  before_filter :find_submission
  
  def create
    @rating = @submission.ratings.build(params[:rating])
	  @rating.admin = has_authority?
	  @rating.user = current_user

	  respond_to do |format|
	    if @submission.users.include?(current_user)
	      flash[:warning] = "Nice try, pal."
	      format.html { redirect_to submission_url(@submission) }
	    elsif @rating.save
		    Updater.update_rating_stats(@submission, @submission.ratings)

        @submission.users.each do |u|
		      u.received_ratings << @rating
		      Updater.update_rating_stats(u, u.received_ratings)
	      end

        format.html { redirect_to submission_url(@submission) }
	    else
	      flash[:warning] = "Unable to save your rating. Please make sure you have entered something."
	      format.html { redirect_to submission_url(@submission) }
      end
	  end
  end

  def update
		@rating = @submission.ratings.find_by_user_id(current_user.id)

	  respond_to do |format|
	    if @rating.update_attributes(params[:rating])
	      Updater.update_rating_stats(@submission, @submission.ratings)
	      @submission.users.each { |u| Updater.update_rating_stats(u, u.received_ratings) }
	      
	      format.html { redirect_to submission_url(@submission) }
      else
        flash[:warning] = 'Unable to save your rating. Please make sure you have entered something.'
        format.html { redirect_to submission_url(@submission) }
      end
    end
  end

  def destroy
    @rating.destroy
    Updater.update_rating_stats(@submission, @submission.ratings)
    @submission.users.each { |u| Updater.update_rating_stats(u, u.received_ratings) }

    respond_to do |format|
      format.html { redirect_to submission_url(@submission) }
    end
  end

  protected

  def authentication_required?
    true
  end

  def find_rating
    begin
      @rating = Rating.find(params[:id]) 
    rescue ActiveRecord::RecordNotFound
      respond_to do |format|
        format.html { render :file => "public/404.html", :status => 404 }
      end
    end
  end

  def find_submission
    begin
      @submission = Submission.find(params[:submission_id]) 
    rescue ActiveRecord::RecordNotFound
      respond_to do |format|
        format.html { render :file => "public/404.html", :status => 404 }
      end
    end
  end
end
