class SessionsController < ApplicationController
  def new
    session[:destination] = request.referer unless session[:destination]
  end

  def create
    if user = User.authenticate(params[:user][:username], params[:user][:password])
	    if user.confirmed?
	      cookies[:authentication_token] = {
          :value => user.authentication_token,
          :expires => 2.weeks.from_now
        } if params[:user][:remember_me] == "1" && user.remember
        
        session[:user] = user.id
	      user.update_attribute(:last_login_time, Time.now)

        if session[:destination]
          redirect_to session[:destination]
          session[:destination] = nil
        else
          redirect_to root_url
        end
	    else
	      flash[:warning] = "Woah there&mdash;you still need to confirm your email address."
        render :action => "new"
	    end
    else
      flash[:warning] = "Please check your username and password."
      render :action => "new"
    end
  end

  def destroy
    current_user.forget
    cookies.delete :authentication_token if cookies[:authentication_token]
    reset_session
    flash[:notice] = "You are now logged out."
    redirect_to :back
  end
end
