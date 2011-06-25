class NotificationsController < ApplicationController
  
  def index
    @user = current_user
    @notifications = @user.notifications
    respond_to do |format|
        format.html
    end
  end
  
  def mass_modify
    
  end
  
  protected
  
  def authentication_required?
    %w(index).include?(action_name)
  end
end
