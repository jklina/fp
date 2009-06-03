class BrowseController < ApplicationController

  before_filter :populate_selection_box
  
  def index
    @submissions = Submission.paginate :page => params[:page], :per_page => 4, :order => 'average_admin_rating_lower_bound DESC', :conditions => { :owner_trash => false, :moderator_trash => false }
	if params[:selection]
	  direct_to_action(params[:selection], params[:sort], params[:order])
	end
  end
  
  #Make this method name plural eventually 
  def category
    @category = Category.find_by_id(params[:selection])
	@submissions = @category.submissions.paginate :page => params[:page], :per_page => 16, :order => params[:sort].select{|name| Submission.column_names.include? (name)}.join(',')+" "+params[:order], :conditions => { :owner_trash => false, :moderator_trash => false }
  end
  
  #maybe this method name should be features instead of featureds?
  def featureds
    @featureds = Featured.paginate :page => params[:page], :per_page => 16, :order => 'id '+params[:order]
  end
  
  def users
	@users = User.paginate :page => params[:page], :per_page => 16,  :order => params[:sort].select{|name| Submission.column_names.include? (name)}.join(',')+" "+params[:order]
  end
  
  protected
  
  def populate_selection_box
    @selection_box_items = [ ["Users", 'users'], ["Featureds", 'featureds'], ["------------", '#'], ["Categories", '#'], ["------------", '#'] ] + Category.find(:all, :order => "title").map {|c| [c.title, c.id]}
  end
  
  def direct_to_action(selection, sort, order)
    case selection
	when "users"
	  redirect_to :action => "users", :selection => selection, :sort => sort, :order => order
	when "featureds"
	  redirect_to :action => "featureds", :selection => selection, :sort => sort, :order => order
    when "#"
	  flash[:warning] = "This is not a valid option. Please select a specific category below."
	  redirect_to :action => "index"
	else
	  redirect_to :action => "category", :selection => selection, :sort => sort, :order => order
	end
  end
end
