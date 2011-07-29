class NotificationsController < ApplicationController
  
  def index
    @user = current_user
    @notifications = @user.notifications
    respond_to do |format|
        format.html
    end
  end
  
  def mass_modify
    @notifications = Notification.find(params[:notification_ids])
    @notifications.each do |notification|
      notification.destroy
    end
    redirect_to notifications_path, :notice => "Deleted notifications!"
  end
  
  protected
  
  def authentication_required?
    %w(index mass_modify).include?(action_name)
  end
end
