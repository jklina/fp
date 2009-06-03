class CommentController < ApplicationController

  before_filter :request_authentication	
  
  def create
    @comment = Comment.new(params[:comment])
	
	#Find the user and the submission the comment will be added to. 
	@user = User.find_by_id(session[:user])
	@submission = Submission.find_by_id(params[:id])
	
	#Add comments
    if (@user.comments << @comment) && (@submission.comments << @comment)
      flash[:notice] = 'Your comment has been posted.'
      redirect_to(:controller => "submission", :action => "show", :id => @submission)
    else
      flash[:warning] = 'Unable to save your comment. Please make sure you have entered something.'
	  redirect_to(:controller => "submission", :action => "show", :id => @submission)
    end

  end

end
