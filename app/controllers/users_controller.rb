class UsersController < ApplicationController
  before_filter :find_user, :except => [ :index, :new, :create ]
  before_filter :require_self, :only => [ :edit, :update, :destroy ]

  def index
	  @users = User.find(:all)

	  respond_to do |format|
	    format.html
    end
  end

  def show
	  @submissions = @user.submissions.paginate :page => params[:page],
	                                            :per_page => 6,
	                                            :order => "created_at DESC",
	                                            :conditions => { :owner_trash => false,
	                                                             :moderator_trash => false }

    @trash = @user.submissions.paginate :page => params[:page],
                                        :per_page => 6,
                                        :order => "created_at DESC",
                                        :conditions => { :owner_trash => true,
                                                         :moderator_trash => false }
	  respond_to do |format|
	    format.html
    end
  end

  def new
    @user = User.new
  end

  def create
	  @user = User.new(params[:user])

    respond_to do |format|
	    if @user.save
	      confirmation_url = url_for :controller => "users", :action => "confirm", :token => @user.confirmation_token
	      Mailer::deliver_confirmation_email(@user, confirmation_url)
	      flash[:notice] = "Thanks for signing up! We've sent a confirmation email to #{@user.email} with instructions on how to activate your account."
	      format.html { redirect_to submissions_url }
	    else
	      flash[:warning] = "There was a problem saving your user."
	      format.html { render :action => "new" }
	    end
	  end
  end

  def edit
  end

  def update
    @user.user_image = UserImage.new(params[:user_image]) if (params[:user_image]) 

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = "User was successfully updated."
        format.html { redirect_to user_url(@user) }
      else
        flash[:warning] = "There was a problem saving your user."
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @user.destroy
    
    respond_to do |format|
      flash[:notice] = "User #{@user.name} deleted"
      format.html { redirect_to users_url }
    end
  end

  def confirm
    respond_to do |format|
      if User.confirm(params[:token])
	      flash[:notice] = "E-mail confirmed, you may now log in!"
	    else
	      flash[:warning] = "Invalid confirmation token; please try again."
	    end

	    format.html { redirect_to login_url }
	  end
  end

  protected

  def authentication_required?
    %w(index edit update destroy).include?(action_name)
  end

  def authority_required?
    %w(index destroy).include?(action_name)
  end

  def find_user
    @user = User.find(params[:id])
  end

  def require_self
    unless @user == current_user
      session[:destination] = request.request_uri
      flash[:warning] = "You aren't authorized to do that."
      redirect_to user_url(@user)
    end
  end
end
