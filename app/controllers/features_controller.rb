class FeaturesController < ApplicationController
  before_filter :find_featured, :only => [ :show, :edit, :update, :destroy ]

  def show
	  @submissions = @featured.submissions.paginate :page => params[:page],
	                                                :per_page => 8,
	                                                :order => "created_on DESC",
	                                                :conditions => { :owner_trash => false,
	                                                                 :moderator_trash => false }
	  respond_to do |format|
      format.html
    end
	end

  def new
    @featured = Featured.new
    @submissions = Submission.find(pending_featured_submissions)
  end

  def create
    @featured = Featured.new(params[:featured])
    @featured.user = current_user
    @featured.featured_image = FeaturedImage.new(params[:featured_image]) if params[:featured_image] && params[:featured_image][:uploaded_data].size != 0

    @submissions = Submission.find(pending_featured_submissions)

    respond_to do |format|
  	  if @submissions.empty?
  	    flash[:warning] = "You don't have any submissions to feature."
  	    format.html { render :action => "new" }
  	  elsif
  	    @featured.save
        @submissions.each do |submission|
	        @featured_association = FeaturedAssociation.new
		      @featured_association.featured = @feature
	        @featured_association.submission = submission
		      @featured_association.save
	      end

	      pending_featured_submissions = []
	      flash[:notice] = "Your featured was saved."
	      format.html { redirect_to feature_url(@featured) }
	    else
	      flash[:warning] = "There was a problem saving your feature."
	      format.html { render :action => "new" }
	    end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @featured.update_attributes(params[:featured])
        flash[:notice] = "Your changes were saved."
        format.html { redirect_to edit_feature_url(@featured) }
      else
        flash[:warning] = "There was a problem saving your feature."
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @featured.destroy

    respond_to do |format|
      flash[:notice] = "Feature successfully deleted."
      format.html { redirect_to root_url }
    end
  end

  protected

  def authentication_required?
    %w(new create edit update destroy).include?(action_name)
  end

  def authority_required?
    %w(new create edit update destroy).include?(action_name)
  end

  def find_featured
    begin
      @featured = Featured.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      respond_to do |format|
        format.html { render :file => "public/404.html", :status => 404 }
      end
    end
  end
end
