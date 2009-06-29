class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?,
                :moderator?, :administrator?, :has_authority?,
                :pending_featured_submissions

  before_filter :request_authentication_if_necessary
  before_filter :redirect_if_unauthorized

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

  def pending_featured_submissions
    session[:pending_featured_submissions] ||= []
  end

  private

  def request_authentication_if_necessary
    if authentication_required? && !current_user
      if cookies[:authentication_token] && (user = User.find_by_authentication_token(cookies[:authentication_token]))
        session[:user] = user.id
      else
        respond_to do |format|
          session[:destination] = request.request_uri
          format.html { redirect_to login_url }
        end
      end
    end
  end

  def redirect_if_unauthorized
    if authority_required? && !has_authority?
      respond_to do |format|
        flash[:warning] = "You must be a moderator or an administrator to do that."
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
end
