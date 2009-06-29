class ReviewsController < ApplicationController
  before_filter :find_submission

  def create
    @review = @submission.reviews.build(params[:review])
    @review.by_administrator = has_authority?
    @review.user = current_user

    respond_to do |format|
      if !@review.unrated? && @submission.authored_by?(current_user)
        flash[:warning] = "Nice try, pal."
        format.html { render :action => "show", :id  => @submission }
      elsif @review.save
        format.html { redirect_to submission_url(@submission) }
      else
        flash[:warning] = "Couldn't save your review. Please try again."
        format.html { render :action => "show", :id  => @submission }
      end
    end
  end

  def update
    @review = @submission.reviews.find_by_user_id(current_user.id)

    respond_to do |format|
      if !@review.rating.blank? && @submission.authored_by?(current_user)
        flash[:warning] = "Nice try, pal."
        format.html { redirect_to submission_url(@submission) }
      elsif @review.update_attributes(params[:review])
        format.html { render :action => "show", :id  => @submission }
      else
        flash[:warning] = "Couldn't update your review. Please try again."
        format.html { render :action => "show", :id  => @submission }
      end
    end
  end

  protected

  def authentication_required?
    true
  end

  def find_review
    @review = Review.find(params[:id]) 
  end

  def find_submission
    @submission = Submission.find(params[:submission_id])
  end
end
