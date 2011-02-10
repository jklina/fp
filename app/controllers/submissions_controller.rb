class SubmissionsController < ApplicationController
  before_filter :find_submission, :except => [ :index, :show, :new, :create, :moderated ]
  before_filter :find_categories, :only => [ :new, :create, :edit, :update ]
  before_filter :require_authorship, :only => [ :edit, :update, :destroy, :trash, :untrash ]

  def index
    @submissions = Submission.paginate :page => params[:page],
                                       :per_page => 16,
                                       :order => "created_at DESC",
                                       :conditions => { :trashed => false,
                                                        :moderated => false },
                                       :include => :users

    respond_to do |format|
      format.html
      format.atom
    end
  end

  def show
    @submission = Submission.find(params[:id], :include => [ :users, { :reviews => :user }, :category ])
    @review = @submission.reviews.find_last_by_user_id(current_user) || Review.new

    respond_to do |format|
        if @submission.trashed
            if @submission.authored_by?(current_user)
                flash[:notice] = "This submission has been trashed. Only you can see it."
                format.html
            else
                raise ActiveRecord::RecordNotFound
            end
        elsif @submission.moderated
            if has_authority?
                flash[:notice] = "This submission has been moderated. Only you and the other moderators can see it."
                format.html
            else
                raise ActiveRecord::RecordNotFound
            end
        else
            @submission.views += 1
            @submission.save!
            format.html
        end
    end
  end

  def new
    @submission = Submission.new
  end

  def create
    @submission = Submission.new(params[:submission])

    respond_to do |format|
      if @submission.save
        authorship = Authorship.new
        authorship.submission = @submission
        authorship.user = current_user
        authorship.save!

	flash[:notice] = "Successfully created your submission!"
	format.html { redirect_to submission_url(@submission) }
      else
	format.html { render :action => "new" }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @submission.update_attributes(params[:submission])
        flash[:notice] = "Your changes were saved."
        format.html { redirect_to edit_submission_url(@submission) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @submission.destroy

    respond_to do |format|
      format.html { redirect_to submissions_url }
    end
  end

  def moderated
    @submissions = Submission.paginate :page => params[:page],
                                       :per_page => 8,
                                       :order => "created_at DESC",
                                       :conditions => { :trashed => false,
                                                        :moderated => true }

    respond_to do |format|
      format.html { render :action => "index" }
    end
  end

  def download
    @submission.downloads += 1
	  @submission.save!

    send_file @submission.download_path
  end

  def trash
    respond_to do |format|
      if @submission.authored_by?(current_user) 
        if @submission.trash
	        flash[:notice] = "&ldquo;#{@submission.title}&rdquo; has been moved to your trash. Only you can see it now."
          format.html { redirect_to submission_url(@submission) }
	      else
	        flash[:warning] = "Couldn&rsquo;t trash your submission. Please contact a moderator."
          format.html { render :action => "show", :id => @submission }
        end
      else
        flash[:warning] = "You must be the submission&rsquo;s author to trash it."
        format.html { render :action => "show", :id => @submission }
	    end
    end
  end

  def untrash
    respond_to do |format|
      if @submission.authored_by?(current_user)
	      if @submission.untrash
	        flash[:notice] = "&ldquo;#{@submission.title}&rdquo; has been removed from your trash. Everyone can see it now."
	        format.html { redirect_to submission_url(@submission) }
	      else
	        flash[:warning] = "Couldn&rsquo;t restore your submission. Please contact a moderator."
          format.html { render :action => "show", :id => @submission }
	      end
      else
        flash[:warning] = "You must be the submission&rsquo;s author to restore it."
        format.html { render :action => "show", :id => @submission }
      end
    end
  end

  def moderate
    respond_to do |format|
      if @submission.moderate
	      flash[:notice] = "&ldquo;#{@submission.title}&rdquo; has been moderated. Only you and the other moderators can see it now."
	      format.html { redirect_to submission_url(@submission) }
	    else
	      flash[:warning] = "Couldn&rsquo;t moderate &ldquo;#{@submission.title}&rdquo;."
	      format.html { render :action => "show", :id => @submission }
	    end
    end
  end

  def unmoderate
    respond_to do |format|
      if @submission.unmoderate
	      flash[:notice] = "#{@submission.title} has been restored. Everyone can see it now."
	      format.html { redirect_to submission_url(@submission) }
	    else
	      flash[:warning] = "Couldn&rsquo;t restore &ldquo;#{@submission.title}&rdquo;."
	      format.html { render :action => "show", :id => @submission }
	    end
    end
  end

  def feature
    respond_to do |format|
      if pending_featured_submissions.include?(@submission.id)
        flash[:warning] = "#{@submission.title} is already waiting to be featured."
        format.html { render :action => "show", :id => @submission }
      else
        pending_featured_submissions << @submission.id
        flash[:notice] = "Added #{@submission.title} to pending featured submissions."
        format.html { redirect_to submission_url(@submission) }
      end
    end
  end

  def unfeature
    respond_to do |format|
      if pending_featured_submissions.delete(@submission.id)
        flash[:notice] = "Removed #{@submission.title} from pending featured submissions."
        format.html { redirect_to new_feature_url }
      else
        flash[:warning] = "#{@submission.title} isn't a pending featured submission."
        format.html { render :template => "features/new" }
      end
    end
  end

  protected

  def authentication_required?
    !%w(index show download).include?(action_name)
  end

  def authority_required?
    %w(moderated moderate unmoderate feature unfeature).include?(action_name)
  end

  def find_submission
    @submission = Submission.find(params[:id])
  end

  def find_categories
    @categories = Category.all
  end

  def require_authorship
    unless @submission.authored_by?(current_user)
      flash[:warning] = "You must be the author of the submission to do that."
      respond_to do |format|
        format.html { render :action => "show", :id => @submission }
      end
    end
  end

  def page_title
    case self.action_name
      when "show" then "#{h(@submission.title)} by #{h(Object.new.extend(SubmissionsHelper).authors(@submission, false))}"
      when "edit" then "Editing &ldquo;#{h(@submission.title)}&rdquo;"
      else super
    end
  end
end
