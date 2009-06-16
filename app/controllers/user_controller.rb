class UserController < ApplicationController

  before_filter :find_user, :only => [ :show, :edit, :update, :destroy, :show_owner_trashed_subs ]
  before_filter :request_user_authentication, :only => [ :edit, :update, :destroy, :show_owner_trashed_subs ]

  def index
	redirect_to :action => 'list'
  end
  
  def create
	if request.post?
	#If there is data incoming try to save it as a user 
	  @user = User.new(params[:user])
      
      if (params[:user_image])
        @user_image = UserImage.new(params[:user_image])  
        #save image to user (may want validation here in the future to make sure the image was added before saving the user)
        @user.user_image = @user_image
      end
      
	  if @user.save
	    flash[:notice] = 'User was successfully created.'
	    redirect_to :action => 'list'
	  else
	    flash[:warning] = 'There was a problem saving your user.'
	    render :action => 'create'
	  end
	end
  end
  
  def edit
  end
  
  def update
    if request.post?
      if (params[:user_image]) 
        @user_image = UserImage.new(params[:user_image])
        @user.user_image = @user_image
      end
	
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        redirect_to(:action => 'show', :id => @user)
      else
	    flash[:warning] = 'There was a problem saving your user.'
        render :action => 'edit'
      end
	end
  end
  
  def show
	#pagnation
	@submissions = @user.submissions.paginate :page => params[:page], :per_page => 6, :order => 'created_on DESC', :conditions => { :owner_trash => false, :moderator_trash => false }
	@user.id == session[:user] ? @userIsSessionUser = true : @userIsSessionUser = false
  end
  
  def show_owner_trashed_subs
    @submissions = @user.submissions.paginate :page => params[:page], :per_page => 6, :order => 'created_on DESC', :conditions => { :owner_trash => true, :moderator_trash => false }
  end
  
  def destroy
	  if request.post?
		  begin
			  user.destroy
			  flash[:notice] = "User #{user.name} deleted"
		  rescue Exception => e
		  	  flash[:notice] = e.message
		  end
	  end
	  redirect_to(:action => :list_users)
  end

  def list
	  @all_users = User.find(:all)
  end
  
  def register
    
	  if request.post?
      @user = User.new(params[:user])

      if @user.save
	  
	      @confirmation_url = url_for(:controller => 'user', :action => 'confirm_email', :confirmation_code => @user.email_confirmation_hash)
		    UserRegMailer::deliver_confirmation_email(@user, @confirmation_url)
		    flash[:notice] = "Thank you for registering! We have sent a confirmation email to #{@user.email} with instructions on how to validate your account."
        redirect_to(:controller => "submission", :action => "list")
	    else 
	      flash[:warning] = "An error occured, your account didn't save properly."
      end
      
    else
	    @user = User.new
    end

  end
  
  def confirm_email
	if User.confirm_email(params[:confirmation_code])
	  redirect_to(:controller => "session", :action => "new")
	  flash[:notice] = "E-mail confirmed, you may now login!"
	else
	  flash[:warning] = "An error occured, it was recorded."
	end
  end
  
  protected
  
  def find_user
    #shows user her own profile if no specific profile is selected
	if params[:id] == nil
		@user = User.find(session[:id])
	else
		@user = User.find(params[:id])
	end
  end
  
  def request_user_authentication
    unless @user.id == (session[:user])
      session[:destination] = request.request_uri
      redirect_to(:action => 'show', :id => @user)
	  #Maybe I should actually log that at some point :^)
	  flash[:warning] = 'There was an error. Your activity and IP address have been logged.'
    end
  end
  
end
