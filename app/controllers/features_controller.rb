class FeaturesController < ApplicationController
  before_filter :find_feature, :only => [ :show, :edit, :update, :destroy ]

  def show
	  @submissions = @feature.submissions.paginate :page => params[:page],
	                                                :per_page => 8,
	                                                :order => "created_at DESC",
	                                                :conditions => { :owner_trash => false,
	                                                                 :moderator_trash => false }
	  respond_to do |format|
      format.html
    end
	end

  def new
    @feature = Feature.new
    @submissions = Submission.find(pending_featured_submissions)
  end

  def create
    @feature = Feature.new(params[:feature])
    @feature.user = current_user
    @feature.feature_image = FeatureImage.new(params[:feature_image]) if params[:feature_image] && params[:feature_image][:uploaded_data].size != 0

    @submissions = Submission.find(pending_featured_submissions)

    respond_to do |format|
  	  if @submissions.empty?
  	    flash[:warning] = "You don't have any submissions to feature."
  	    format.html { render :action => "new" }
  	  elsif
  	    @feature.save
        @submissions.each do |submission|
	        @featuring = Featuring.new
		      @featuring.feature = @feature
	        @featuring.submission = submission
		      @featuring.save
	      end

	      pending_featured_submissions = []
	      flash[:notice] = "Your feature was saved."
	      format.html { redirect_to feature_url(@feature) }
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
      if @feature.update_attributes(params[:feature])
        flash[:notice] = "Your changes were saved."
        format.html { redirect_to edit_feature_url(@feature) }
      else
        flash[:warning] = "There was a problem saving your feature."
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @feature.destroy

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

  def find_feature
    begin
      @feature = Feature.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      respond_to do |format|
        format.html { render :file => "public/404.html", :status => 404 }
      end
    end
  end
end