class SessionsController < ApplicationController
  def new
  end

  def create
    if user = User.authenticate(params[:user][:username], params[:user][:password])
	    if user.confirmed?
	      session[:user] = user.id
	      user.last_login_time = Time.now

        if session[:destination]
          redirect_to session[:destination]
          session[:destination] = nil
        else
          redirect_to root_url
        end
	    else
	      flash[:warning] = "Please confirm your email address."
        render :action => "new"
	    end
    else
      flash[:warning] = "Please check your username and password."
      render :action => "new"
    end
  end

  def destroy
    reset_session
    flash[:notice] = "You are now logged out."
    redirect_to root_url
  end
end
