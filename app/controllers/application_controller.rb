class ApplicationController < ActionController::Base
  helper :submissions

  helper_method :current_user, :logged_in?,
                :moderator?, :administrator?, :has_authority?, :has_admin_authority?,
                :pending_featured_submissions,
                :page_title

  before_filter :authenticate_by_token_if_present
  before_filter :request_authentication_if_necessary
  before_filter :redirect_if_unauthorized
  before_filter :find_headline

  filter_parameter_logging :password, :password_confirmation

  rescue_from ActiveRecord::RecordNotFound, :with => :respond_with_404
  rescue_from ActionController::RedirectBackError, :with => :handle_referrerless_redirect

  protected

  def authentication_required?
    false
  end

  def authority_required?
    false
  end
  
  def admin_authority_required?
    false
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user])
  end

  def logged_in?
    current_user
  end

  def moderator?
    logged_in? && current_user.access_level >= User::Role::MODERATOR
  end

  def administrator?
    logged_in? && current_user.access_level >= User::Role::ADMINISTRATOR
  end

  def has_authority?
    moderator? || administrator?
  end
  
  def has_admin_authority?
    administrator?
  end

  def pending_featured_submissions
    session[:pending_featured_submissions] ||= []
  end

  def page_title
    case self.action_name
      when "index" then "All #{self.controller_name.capitalize}"
      when "new" then "New #{self.controller_name.capitalize.singularize}"
      else nil
    end
  end

  private

  def authenticate_by_token_if_present
    if !current_user && cookies[:authentication_token]
      u = User.find_by_authentication_token(cookies[:authentication_token])
      session[:user] = u.id if u
    end
  end

  def request_authentication_if_necessary
    if authentication_required? && !current_user
      respond_to do |format|
        session[:destination] = request.request_uri
        format.html { redirect_to login_url }
      end
    end
  end

  def redirect_if_unauthorized
    if authority_required? && !has_authority?
      respond_to do |format|
        flash[:warning] = "You must be a moderator or an administrator to do that."
        format.html { redirect_to :back }
      end
	elsif admin_authority_required? && !has_admin_authority?
      respond_to do |format|
        flash[:warning] = "You must be an administrator to do that."
        format.html { redirect_to :back }
      end
	end
  end

  def respond_with_404
    respond_to do |format|
      format.html { render :file => "public/404.html", :status => 404 }
    end
  end

  def handle_referrerless_redirect
    respond_to do |format|
      format.html { redirect_to root_url }
    end
  end
  
  def find_headline
    a = Announcement.last
    @headline = a && a.created_at > 7.days.ago ? a : nil
  end
end
