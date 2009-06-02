class SuperAdmin::UserController < SuperAdmin::BaseController
  
  before_filter :find_user, :only => [ :show, :edit, :update, :destroy ]
  
  def index
	redirect_to :action => 'list'
  end
  
  def new
    @user = User.new
  end
  
  def create
	if request.post?
	#If there is data incoming try to save it as a user 
	  @user = User.new(params[:user])
      
      if (params[:user_image][:uploaded_data].size != 0)
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
      if (params[:user_image][:uploaded_data].size != 0) 
        @user_image = UserImage.new(params[:user_image])
        @user.user_image = @user_image
      end
	
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        redirect_to(:action => 'show', :id => @user)
      else
	    flash[:warning] = 'There was a problem saving your user.'
        render :action => 'update'
      end
	end
  end
  
  def show
	#pagnation
	@submissions = @user.submissions.paginate :page => params[:page], :per_page => 6, :order => 'created_on DESC'
  end

  def destroy
	  if request.post?
		  begin
			  @user.destroy
			  flash[:notice] = "User #{@user.name} deleted"
		  rescue Exception => e
		  	  flash[:notice] = e.message
		  end
	  end
	  redirect_to(:action => :list)
  end

  def list
	  @all_users = User.find(:all)
  end
  
  protected
  
  def find_user
    @user = User.find(params[:id])
  end
end
