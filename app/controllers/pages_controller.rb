class PagesController < ApplicationController
  def root
    @submissions = Submission.paginate :page => params[:page],
                                       :per_page => 12,
                                       :order => "created_at DESC",
                                       :conditions => { :trashed => false,
                                                        :moderated => false },
                                       :include => :users

    if Feature.last	  
      @feature = Feature.last
    end

    respond_to do |format|
      format.html
    end
  end

  def browse
    @selectables = [
      [ "All Submissions", "submissions" ],
      [ "Featured Submissions", "featured" ],
      [ "Users",           "users" ],
      [ "--------------------", "#"]
    ] + Category.order("title").map { |c| [ c.title, c.id ] }

    @orders = [
      [ "Newest first", 0 ],
      [ "Oldest first", 1 ],
      [ "Highest user rating first", 2 ],
      [ "Lowest user rating first", 3 ]
    ]

    session[:order_filter]  = params[:order] if params[:order]
    session[:things_filter] = params[:things] if params[:things]

    order = case session[:order_filter].to_i
      when 1 then "created_at ASC"
      when 2 then "average_rating DESC"
      when 3 then "average_rating ASC"
      else "created_at DESC"
    end

    case session[:things_filter]
      when nil, "submissions", "#"
        @renderables = Submission.paginate :page => params[:page],
                                           :per_page => 16,
                                           :order => order,
                                           :conditions => { :trashed => false,
                                                            :moderated => false },
                                           :include => :users
        @fragment = "submissions/submission"
      when "featured"
        @renderables = Submission.paginate :page => params[:page],
                                           :per_page => 16,
                                           :order => order,
                                           :conditions => [ "trashed = ? AND moderated = ? AND featured_at != ?", false, false, "" ],
                                           :include => :users
        @fragment = "submissions/submission"
      when "users"
        @renderables = User.paginate :page => params[:page],
                                     :per_page => 16,
                                     :order => order
        @fragment = "users/user"
      else
        @renderables = Submission.paginate :page => params[:page],
                                           :per_page => 16,
                                           :order => order,
                                           :conditions => { :trashed => false,
                                                            :moderated => false,
                                                            :category_id => session[:things_filter].to_i },
                                           :include => :users
        @fragment = "submissions/submission"
    end

    respond_to do |format|
      format.html
    end
  end
end
