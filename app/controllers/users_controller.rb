class UsersController < ApplicationController
  before_filter :find_user, :except => [ :index, :show, :new, :create, :confirm ]
  before_filter :require_self, :only => [ :edit, :update, :destroy ]

  def index
	  @users = User.find(:all)

	  respond_to do |format|
	    format.html
    end
  end

  def show
    @user = User.find(params[:id], :include => [ :submissions,  { :reviews => [ :user, :submission ] } ])

    @submissions = @user.submissions.find(:all,
	                                        :limit => 4,
	                                        :order => "submissions.created_at DESC",
	                                        :conditions => { :trashed => false,
	                                                         :moderated => false })

    @reviews = @user.reviews.find :all,
	                                :limit => 4,
	                                :order => "reviews.created_at DESC"

    @trash = @user.submissions.find(:all,
                                    :limit => 4,
                                    :order => "submissions.created_at DESC",
                                    :conditions => { :trashed => true,
                                                     :moderated => false })
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
	      flash[:notice] = "Thanks for signing up! We've sent a confirmation email to #{h(@user.email)} with instructions on how to activate your account."
	      format.html { redirect_to submissions_url }
	    else
	      format.html { render :action => "new" }
	    end
	  end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = "Your changes were saved."
        format.html { redirect_to user_url(@user) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @user.destroy
    
    respond_to do |format|
      format.html { redirect_to users_url }
    end
  end

  def confirm
    respond_to do |format|
      if User.confirm(params[:token])
	      flash[:notice] = "E-mail confirmed, you're all clear to log in!"
	      format.html { redirect_to login_url }
	    else
	      flash[:warning] = "Invalid confirmation token; please try again."
	      format.html { render :template => "sessions/new" }
	    end
	  end
  end

  protected

  def authentication_required?
    %w(edit update destroy).include?(action_name)
  end

  def authority_required?
    %w(destroy).include?(action_name)
  end

  def find_user
    @user = User.find(params[:id])
  end

  def require_self
    respond_to do |format|
      flash[:warning] = "You aren't authorized to do that."
      format.html { render :action => "show", :id => @user }
    end unless @user == current_user
  end

  def page_title
    case self.action_name
      when "show" then @user == current_user ? "Your Profile" : h(@user.username)
      when "new"  then "Sign up for an account"
      when "edit" then "Editing your account"
      else super
    end
  end
end
