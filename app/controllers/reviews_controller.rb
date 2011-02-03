class ReviewsController < ApplicationController
  before_filter :find_submission, :only => [ :update ]

  def create
    @submission = Submission.find(params[:submission_id])
    @review = @submission.reviews.build(params[:review])
    @review.by_administrator = has_authority?
    @review.user = current_user

    respond_to do |format|
      if !@review.unrated? && @submission.authored_by?(current_user)
        flash[:warning] = "Nice try, pal."
        format.html { redirect_to(@submission) }
      elsif @review.save
        format.html { redirect_to(@submission) }
      else
        flash[:warning] = "Couldn't save your review. Please try again."
        format.html { redirect_to(@submission) }
      end
    end
  end

  def update
    @review = Review.where(:submission_id => @submission.id, :user_username => current_user.username).last

    respond_to do |format|
      if !@review.unrated? && @submission.authored_by?(current_user)
        flash[:warning] = "Nice try, pal."
        format.html { redirect_to(@submission) }
      elsif @review.update_attributes(params[:review])
        format.html { redirect_to(@submission) }
      else
        flash[:warning] = "Couldn't update your review. Please try again."
        format.html { redirect_to(@submission) }   
	  end
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy

    respond_to do |format|
      flash[:notice] = "Review deleted."
      #hack to redirect back
      format.html { redirect_to :back}
	  end
  end

  protected

  def authentication_required?
    true
  end
  
  def authority_required?
    %w(destroy).include?(action_name)
  end

  def find_submission
    @submission = Submission.find(params[:submission_id])
  end
end
