class BrowseController < ApplicationController
  before_filter :populate_selection_box
  
  def index
    @submissions = Submission.paginate :page => params[:page],
                                       :per_page => 12,
                                       :order => "average_admin_rating_lower_bound DESC",
                                       :conditions => { :owner_trash => false,
                                                        :moderator_trash => false }

    if params[:selection]
	    dispatch(params[:selection], params[:sort], params[:order])
    else
      respond_to do |format|
        format.html
      end
    end
  end

  def category
    if params[:selection]
	    @category = Category.find_by_id(params[:selection])
	    @submissions = @category.submissions.paginate :page => params[:page],
	                                                  :per_page => 12,
	                                                  :order => "#{params[:sort].select{ |name| Submission.column_names.include?(name) }.join(',')} #{params[:order]}",
	                                                  :conditions => { :owner_trash => false,
	                                                                   :moderator_trash => false }
	  else
	    @category = Category.find_by_id(params[:id])
	    @submissions = @category.submissions.paginate :page => params[:page],
	                                                  :per_page => 12,
	                                                  :order => "average_admin_rating_lower_bound DESC",
	                                                  :conditions => { :owner_trash => false,
	                                                                   :moderator_trash => false }
	  end

    respond_to do |format|
      format.html
    end
  end
  
  def featureds
    @featureds = Featured.paginate :page => params[:page],
                                   :per_page => 12,
                                   :order => "id #{params[:order]}"

    respond_to do |format|
      format.html
    end
  end
  
  def users
	  @users = User.paginate :page => params[:page],
	                         :per_page => 12,
	                         :order => "#{params[:sort].select{ |name| Submission.column_names.include?(name) }.join(',')} #{params[:order]}"
    respond_to do |format|
      format.html
    end
  end

  protected
  
  def populate_selection_box
    @selection_box_items = [ ["Users", 'users'], ["Featureds", 'featureds'], ["------------", '#'], ["Categories", '#'], ["------------", '#'] ] + Category.find(:all, :order => "title").map {|c| [c.title, c.id]}
  end

  def dispatch(selection, sort, order)
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
