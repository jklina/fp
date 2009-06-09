# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  layout :determine_layout
  
  #helper :all # include all helpers, all the time

  #before_filter :request_authentication_if_necessary

  filter_parameter_logging :password, :password_confirmation
  
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_pixelfuckers.org_session_id'
  
  def index
    @submissions = Submission.paginate :page => params[:page], :per_page => 16, :order => 'created_on DESC', :conditions => { :owner_trash => 'false', :moderator_trash => 'false' }
	@featured = Featured.find(:last)
  end
  
  protected
  
  private
  
  def determine_layout
    if @logged_in_user = User.find_by_id(session[:user])
	  #Get user name for layout header
	  
	  template = @logged_in_user.access_level.to_s
	else
	  template = "0"
	end
  end
  
  def request_authentication
	unless ((@user = User.find_by_id(session[:user])) && @user.access_level > User.unregistered_user)
      session[:destination] = request.request_uri
      redirect_to(:controller => "session", :action => "new")
    end
  end
  
  def request_admin_authentication
   unless ((@user = User.find_by_id(session[:user])) && @user.access_level > User.registered_user)
	  session[:destination] = request.request_uri
      redirect_to(:controller => "/session", :action => "new")
	end
  end
  
   def request_super_admin_authentication
   unless ((@user = User.find_by_id(session[:user])) && @user.access_level > User.moderator)
	  session[:destination] = request.request_uri
      redirect_to(:controller => "/session", :action => "new")
	end
  end
end
