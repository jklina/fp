class FeatureController < ApplicationController

  def show
    #@featured = Featured.find(:last)
	@featured = Featured.find(params[:id])
	@featured_submissions = @featured.submissions.paginate :page => params[:page], :per_page => 8, :order => 'created_on DESC', :conditions => { :owner_trash => false, :moderator_trash => false }  end

end
