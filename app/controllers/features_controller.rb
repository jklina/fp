class FeaturesController < ApplicationController
  before_filter :find_feature, :except => [ :index, :show, :new, :create ]

  def index
    @features = Feature.paginate :page => params[:page],
                                 :per_page => 16,
                                 :order => "created_at DESC",
                                 :include => :user

    respond_to do |format|
      format.html
    end
  end

  def show
    @feature = Feature.find(params[:id])
    
    if (@feature.submissions.size == 1)
      redirect_to submission_url(@feature.submissions.first)
      return
    end

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

    @submissions = Submission.find(pending_featured_submissions)

    respond_to do |format|
  	  if @submissions.empty?
  	    flash[:warning] = "You don't have any submissions to feature."
  	    format.html { render :action => "new" }
  	  elsif @feature.save
        @submissions.each do |submission|
	        featuring = Featuring.new
		      featuring.feature = @feature
	        featuring.submission = submission
		      featuring.save!
	      end

	      pending_featured_submissions = []
	      flash[:notice] = "Successfully featured your submissions!"
	      format.html { redirect_to feature_url(@feature) }
	    else
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
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @feature.destroy

    respond_to do |format|
      flash[:notice] = "Feature deleted."
      format.html { redirect_to features_url }
    end
  end

  protected

  def authentication_required?
    authority_required?
  end

  def authority_required?
    %w(new create edit update destroy).include?(action_name)
  end

  def find_feature
    @feature = Feature.find(params[:id])
  end

  def page_title
    case self.action_name
      when "show" then h(@feature.title)
      when "edit" then "Editing &ldquo;#{h(@feature.title)}&rdquo;"
      else super
    end
  end
end
