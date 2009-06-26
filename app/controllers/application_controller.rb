class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?,
                :moderator?, :administrator?, :has_authority?,
                :pending_featured_submissions

  before_filter :request_authentication_if_necessary
  before_filter :redirect_if_unauthorized

  filter_parameter_logging :password, :password_confirmation

  rescue_from ActiveRecord::RecordNotFound, :with => :respond_with_404

  def index
    @submissions = Submission.paginate  :page => params[:page],
                                        :per_page => 16,
                                        :order => "created_at DESC",
                                        :conditions => { :owner_trash => false,
                                                         :moderator_trash => false }
	  @feature = Feature.find(:last)
  end

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
    !current_user.nil?
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

  def local_request?
    false
  end

  private

  def request_authentication_if_necessary
    if authentication_required? && current_user.nil?
      session[:destination] = request.request_uri
      redirect_to login_url
    end
  end

  def redirect_if_unauthorized
    if authority_required? && !has_authority?
      flash[:warning] = "You must be a moderator or an administrator to do that."
      redirect_to root_url
    end
  end

  def respond_with_404
    respond_to do |format|
      format.html { render :file => "public/404.html", :status => 404 }
    end
  end
end
