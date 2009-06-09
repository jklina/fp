class SubmissionController < ApplicationController

  require "statistics/statistics2"
  
  before_filter :find_submission, :find_submission_users, :only => [ :show, :edit, :update, :destroy, :move_to_owners_trash, :remove_from_owners_trash, :download, :list_ratings, :list_moderator_ratings ]
  before_filter :request_authentication, :find_all_categories, :only => [ :new, :create, :edit ]
  before_filter :request_submission_author_authentication, :only => [ :edit, :update, :destroy, :move_to_owners_trash, :remove_from_owners_trash ]
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @submissions = Submission.paginate :page => params[:page], :per_page => 8, :order => 'created_on DESC', :conditions => { :owner_trash => false, :moderator_trash => false }
  end
  
  def list_ratings
    @ratings = Rating.paginate :page => params[:page], :per_page => 24, :order => 'created_at DESC', :conditions => { :admin => false, :submission_id => @submission.id }
  end
   
  def list_moderator_ratings
    @ratings = Rating.paginate :page => params[:page], :per_page => 24, :order => 'created_at DESC', :conditions => { :admin => true, :submission_id => @submission.id }
  end

  def show
    unless @submission.trashed?
      @comment_list = @submission.comments
	
	  if @rating = @submission.ratings.find_by_user_id(session[:user])
	    @user_has_rated = true
	  end
	
	  @submission.users.find_by_id(session[:user]) ? @userIsOwner = true : @userIsOwner = false
	  
	  @counts = @submission.ratings.count(:group => :admin)

	  @numOfAdminRatings = @counts[true].to_i
	  @numOfRatings = @counts[false].to_i
	  
	  #Add one to the total number of views and save
	  @submission.views += 1
	  @submission.save
	
	else
	  #redirect_to :back, isn't working so I'm writing out the long form. 
	  redirect_to(request.env["HTTP_REFERER"])
	  flash[:notice] = "This submission has been trashed."
	end
  end
  
  def download
    @submission.downloads += 1
	@submission.save
    redirect_to @submission.sub_file.public_filename
  end

  def new
    @submission = Submission.new
  end

  def create
    @submission = Submission.new(params[:submission])
	
	#new submission is not trashed, set it that way.
	@submission.owner_trash = false
	@submission.moderator_trash = false
	
	@submission_association = SubmissionAssociation.new
	
	#make sure there is data there before saving the submission_file
    if (params[:sub_file][:uploaded_data].size != 0) 
      @sub_file =  SubFile.new(params[:sub_file])
	  @submission.sub_file = @sub_file
    end
	
	@sub_image = SubImage.new(params[:sub_image])  
    #save image to submission
    @submission.sub_image = @sub_image
 
	if @submission.save
      #Add the current user to the item so the item has an author (add support for multiple users later)
      @submission_association.submission = @submission
      @submission_association.user = User.find_by_id(session[:user])
	  #Add the item to a category
      @Category = Category.find(params[:category][:id])
      @Category.submissions << @submission
	  if @submission_association.save
	    flash[:notice] = 'Submission was successfully created.'
	    redirect_to :action => 'list'
	  else
	    flash[:warning] = 'There was a problem saving your submission (association).'
		render :action => 'new'
	  end
	else
	  flash[:warning] = 'There was a problem saving your submission.'
	  render :action => 'new'
	end
  end

  def edit
  end

  def update	
    @submission.category = Category.find(params[:category][:id])
    if (params[:sub_image][:uploaded_data].size != 0) 
      @sub_image = SubImage.new(params[:sub_image])
      @submission.sub_image = @sub_image
    end
    if ( params[:sub_file][:uploaded_data].size != 0)  
      @sub_file = SubFile.new(params[:sub_file])
      @submission.sub_file = @sub_file
    end
	
    if @submission.update_attributes(params[:submission])
      flash[:notice] = 'Submission was successfully updated.'
      redirect_to :action => 'show', :id => @submission
    else
      render :action => 'edit'
    end
  end

  def destroy
    @submission.destroy
    redirect_to :action => 'list'
  end
  
  def move_to_owners_trash
    @submission.owner_trash = true
	if @submission.save
	  flash[:notice] = "Your submission " + @submission.title.to_s + " has been moved to your trash. It is not viewable by the public."
	  redirect_to :action => 'show', :id => @submission
	else
	  flash[:warning] = "There was a problem trashing your submission. Please contact the staff."
	  redirect_to :action => 'show', :id => @submission
	end
  end
  
  def remove_from_owners_trash
    @submission.owner_trash = false
	if @submission.save
	  flash[:notice] = "Your submission " + @submission.title.to_s + " has been removed from your trash. It is now viewable by the public."
	  redirect_to :action => 'show', :id => @submission
	else
	  flash[:warning] = "There was a problem restoring your submission. Please contact the staff."
	  redirect_to :action => 'show', :id => @submission
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
  
  def request_submission_author_authentication
    #might be able to replace this with @logged_in_user later.
    unless @users.find_by_id(session[:user])
      session[:destination] = request.request_uri
      redirect_to(:controller => "submission", :action => "list")
	  #Maybe I should actually log that at some point :^)
	  flash[:warning] = 'There was an error. Your activity has been logged and IP address have been logged.'
    end
  end
end
