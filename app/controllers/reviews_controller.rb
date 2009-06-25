class ReviewsController < ApplicationController
  before_filter :find_submission

  def create
    @review = @submission.reviews.build(params[:review])
    @review.by_administrator = has_authority?
    @review.user = current_user

    respond_to do |format|
      if !@review.unrated? && @submission.authored_by?(current_user)
        flash[:warning] = "Nice try, pal."
        format.html { redirect_to submission_url(@submission) }
      elsif @review.save
        format.html { redirect_to submission_url(@submission) }
      else
        flash[:warning] = "Couldn't save your review. Please try again."
        format.html { redirect_to submission_url(@submission) }
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
        format.html { redirect_to submission_url(@submission) }
      else
        flash[:warning] = "Couldn't update your review. Please try again."
        format.html { redirect_to submission_url(@submission) }
      end
    end
  end

  protected

  def authentication_required?
    true
  end

  def find_review
    begin
      @review = Review.find(params[:id]) 
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
