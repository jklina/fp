class Admin::SubmissionController < ApplicationController
  
  before_filter :find_submission, :find_submission_users, :only => [ :move_to_moderator_trash, :remove_from_moderator_trash ]
  
  def show_moderator_trashed_subs
    @submissions = Submission.paginate :page => params[:page], :per_page => 8, :order => 'created_on DESC', :conditions => { :owner_trash => false, :moderator_trash => true }
  end
  
  def move_to_moderator_trash
    @submission.moderator_trash = true
	if @submission.save
	  flash[:notice] = @submission.title.to_s + " has been moved to your trash. It is no longer viewable by the public."
	  #redirect_to :back, isn't working so I'm writing out the long form. 
	  redirect_to :controller => '/admin/submission', :action => 'show_moderator_trashed_subs'
	else
	  flash[:warning] = "There was a problem trashing the submission. Please contact the staff."
	  redirect_to :controller => '/submission', :action => 'show', :id => @submission
	end
  end
  
  def remove_from_moderator_trash
    @submission.moderator_trash = false
	if @submission.save
	  flash[:notice] = @submission.title.to_s + " has been removed from your trash. It is now viewable by the public."
	  redirect_to :controller => '/admin/submission', :action => 'show_moderator_trashed_subs'
	else
	  flash[:warning] = "There was a problem restoring this submission. Please contact the staff."
	  redirect_to :controller => '/admin/submission', :action => 'show_moderator_trashed_subs'
	end
  end
  
  protected
  
  def find_submission
    @submission = Submission.find(params[:id])
  end
  
  def find_submission_users
    @users = @submission.users
  end
  
  def find_all_categories
    @categories = Category.find(:all)
  end
 
end
