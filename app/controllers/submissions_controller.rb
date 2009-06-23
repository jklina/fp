class SubmissionsController < ApplicationController
  before_filter :find_submission, :except => [ :index, :new, :create, :moderated ]
  before_filter :find_category, :only => [ :create, :update ]
  before_filter :find_categories, :only => [ :new, :create, :edit, :update ]
  before_filter :require_authorship, :only => [ :edit, :update, :destroy, :trash, :untrash ]

  def index
    @submissions = Submission.paginate :page => params[:page],
                                       :per_page => 8,
                                       :order => "created_on DESC",
                                       :conditions => { :owner_trash => false,
                                                        :moderator_trash => false }

    respond_to do |format|
      format.html
    end
  end

  def show
    @comment = @submission.comments.find_by_user_id(current_user) || Comment.new
    @rating = @submission.ratings.find_by_user_id(current_user) || Rating.new

    respond_to do |format|
      if @submission.trashed?
        if @submission.authored_by?(current_user)
          flash[:notice] = "This submission has been trashed. Only you can see it."
  	      format.html
	      else
	        format.html { render :file => "public/404.html", :status => 404 }
        end
      elsif @submission.moderated?
        if has_authority?
          flash[:notice] = "This submission has been moderated. Only you and the other moderators can see it."
  	      format.html
        else
          format.html { render :file => "public/404.html", :status => 404 }
        end
	    else
  	    @submission.views += 1
  	    @submission.save

        format.html
      end
    end
  end

  def new
    @submission = Submission.new
  end

  def create
    @submission = Submission.new(params[:submission])

	  @submission.owner_trash = false
	  @submission.moderator_trash = false
    @submission.category = @category
	  @submission.sub_file = SubFile.new(params[:sub_file]) if params[:sub_file] 
    @submission.sub_image = SubImage.new(params[:sub_image])  
 
    respond_to do |format|
	    if @submission.save
	      submission_association = SubmissionAssociation.new
        submission_association.submission = @submission
        submission_association.user = current_user
      
	      if submission_association.save
	        flash[:notice] = "Submission was successfully created."
	        format.html { redirect_to submissions_url }
	      else
	        flash[:warning] = "There was a problem saving your submission (association)."
		      format.html { render :action => "new" }
	      end
	    else
	      flash[:warning] = "There was a problem saving your submission."
	      format.html { render :action => "new" }
	    end
    end
  end

  def edit
  end

  def update
    @submission.category = @category
    @submission.sub_image = SubImage.new(params[:sub_image]) if (params[:sub_image])
    @submission.sub_file = SubFile.new(params[:sub_file]) if (params[:sub_file])

    respond_to do |format|
      if @submission.update_attributes(params[:submission])
        flash[:notice] = "Submission was successfully updated."
        format.html { redirect_to submission_url(@submission) }
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
                                       :order => "created_on DESC",
                                       :conditions => { :owner_trash => false,
                                                        :moderator_trash => true }

    respond_to do |format|
      format.html
    end
  end

  def download
    @submission.downloads += 1
	  @submission.save

    send_file @submission.download_filename
  end

  def trash
    respond_to do |format|
      if @submission.authored_by?(current_user) 
        if @submission.trash
	        flash[:notice] = "Your submission #{@submission.title} has been moved to your trash. It is not viewable by the public."
          format.html { redirect_to submission_url(@submission) }
	      else
	        flash[:warning] = "There was a problem trashing your submission. Please contact the staff."
          format.html { redirect_to submission_url(@submission) }
        end
      else
        flash[:warning] = "You must be the submission's author to trash it."
        format.html { redirect_to submission_url(@submission) }
	    end
    end
  end

  def untrash
    respond_to do |format|
      if @submission.authored_by?(current_user)
	      if @submission.untrash
	        flash[:notice] = "Your submission #{@submission.title} has been removed from your trash. It is now viewable by the public."
	        format.html { redirect_to submission_url(@submission) }
	      else
	        flash[:warning] = "There was a problem restoring your submission. Please contact the staff."
	        format.html { redirect_to submission_url(@submission) }
	      end
      else
        flash[:warning] = "You must be the submission's author to restore it."
        format.html { redirect_to submission_url(@submission) }
      end
    end
  end

  def moderate
    respond_to do |format|
      if @submission.moderate
	      flash[:notice] = "#{@submission.title} has been moderated. It is not viewable by the public."
	      format.html { redirect_to submission_url(@submission) }
	    else
	      flash[:warning] = "There was a problem trashing your submission. Please contact the staff."
	      format.html { redirect_to submission_url(@submission) }
	    end
    end
  end

  def unmoderate
    respond_to do |format|
      if @submission.unmoderate
	      flash[:notice] = "#{@submission.title} has been unmoderated. It is now viewable by the public."
	      format.html { redirect_to submission_url(@submission) }
	    else
	      flash[:warning] = "There was a problem trashing your submission. Please contact the staff."
	      format.html { redirect_to submission_url(@submission) }
	    end
    end
  end

  def feature
    respond_to do |format|
      if pending_featured_submissions.include?(@submission.id)
        flash[:warning] = "#{@submission.title} is already waiting to be featured."
        format.html { redirect_to submission_url(@submission) }
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
        format.html { redirect_to submission_url(@submission) }
      else
        flash[:warning] = "#{@submission.title} isn't a pending featured submission."
        format.html { redirect_to submission_url(@submission) }
      end
    end
  end

  protected

  def authentication_required?
    %w(new create edit update destroy trash untrash moderate unmoderate feature unfeature).include?(action_name)
  end

  def authority_required?
    %w(moderated moderate unmoderate feature unfeature).include?(action_name)
  end

  def find_submission
    begin
      @submission = Submission.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      respond_to do |format|
        format.html { render :file => "public/404.html", :status => 404 }
      end
    end
  end

  def find_category
    begin
      @category = Category.find(params[:category][:id])
    rescue ActiveRecord::RecordNotFound
      respond_to do |format|
        format.html { render :file => "public/404.html", :status => 404 }
      end
    end
  end

  def find_categories
    @categories = Category.find(:all)
  end

  def require_authorship
    unless @submission.authored_by?(current_user)
      flash[:warning] = "You must be the author of the submission to do that."
      redirect_to submission_url(@submission)
    end
  end
end
