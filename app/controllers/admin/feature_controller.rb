class Admin::FeatureController < ApplicationController

  def add_to_featured_cart
    submission = Submission.find(params[:id])
	@featured_cart = find_featured_cart
	if @featured_cart.items.find {|item| item.id == submission.id}
	  flash[:warning] = 'You\'ve already added this submission to your Feature!'
	else
	  @featured_cart.add_submission(submission)
	  flash[:notice] = 'You added '+submission.title.to_s+' to your Feature.'
	end
	redirect_to :action => "view_featured_cart"
  end
  
  def remove_from_featured_cart
	@featured_cart = find_featured_cart
	if @featured_cart.remove_submission(params[:index].to_i)
	  flash[:notice] = 'You\'ve removed the submission successfully.'
	else
	  flash[:notice] = 'There was a problem removing the submission.'
	end
	redirect_to :action => "view_featured_cart"
  end
  
  def view_featured_cart
    @featured_cart = find_featured_cart
  end
  
  def create
    
	
    
    @featured = Featured.new(params[:featured])
	
    if (params[:featured_image][:uploaded_data].size != 0)
      @featured_image = FeaturedImage.new(params[:featured_image])  
      #save image to user (may want validation here in the future to make sure the image was added before saving the user)
    @featured.featured_image = @featured_image
    end

  	if @featured.save
	
	  if @logged_in_user = User.find_by_id(session[:user])
	    @logged_in_user.featureds << @featured
	  end
	  
      @featured_cart = find_featured_cart
	  
	  #Creates a featured_association for each Submission. All the Submissions have the same Featured in the association.
	  @featured_cart.items.each do |submission|
	    @featured_association = FeaturedAssociation.new
		@featured_association.featured = @featured
	    @featured_association.submission = submission
		@featured_association.save
	  end

	  session[:featured_cart] = nil
	  flash[:notice] = 'Your Featured was saved.'
	  redirect_to :controller => "/application"
	else
	  flash[:warning] = 'There was a problem saving your Featured.'
	  reload
	end
  end
  
  private
  
  def find_featured_cart
    session[:featured_cart] ||= FeaturedCart.new
  end

end
