class SessionController < ApplicationController
  def new
  end

  def create
    if user = User.authenticate(params[:user][:username], params[:user][:password])
	  
	  if user.email_confirmation?
	    session[:user] = user.id
        if session[:destination]
          redirect_to session[:destination]
          session[:destination] = nil
        else
          redirect_to(:controller => "submission", :action => "list")
        end
	  else
	    flash[:warning] = 'Please confirm your e-mail.'
        render :action => 'new'
	  end
    else
      flash[:warning] = 'Please check your name and password.'
      render :action => 'new'
    end
  end

  def destroy
    reset_session
    flash[:notice] = 'You are now logged out.'
    redirect_to(:controller => "submission", :action => "list")
  end
end
