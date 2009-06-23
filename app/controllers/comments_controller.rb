class CommentsController < ApplicationController
  before_filter :find_submission

  def create
    @comment = @submission.comments.build(params[:comment])
    @comment.user = current_user

	  respond_to do |format|
      if @comment.save
        format.html { redirect_to submission_url(@submission) }
      else
        flash[:warning] = "Unable to save your comment. Please make sure you have entered something."
        format.html { redirect_to submission_url(@submission) }
      end
    end
  end

  protected

  def authentication_required?
    true
  end

  def find_submission
    begin
      @submission = Submission.find(params[:submission_id])
    rescue ActiveRecord::RecordNotFound
      respond_to do |html|
        format.html { render :file => "public/404.html", :status => 404 }
      end
    end
  end
end
