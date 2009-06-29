class PagesController < ApplicationController
  def root
    @submissions = Submission.paginate :page => params[:page],
                                       :per_page => 16,
                                       :order => "created_at DESC",
                                       :conditions => { :trashed => false,
                                                        :moderated => false },
                                       :include => :users

	  @feature = Feature.find :last, :include => :user

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
    ] + Category.find(:all, :order => "title").map { |c| [ c.title, c.id ] }

    @orders = [
      [ "Newest first", 0 ],
      [ "Oldest first", 1 ],
      [ "Highest user rating first", 2 ],
      [ "Lowest user rating first", 3 ]
    ]

    case params[:order].to_i
      when 1
        order = "created_at ASC"
      when 2
        order = "user_rating DESC"
      when 3
        order = "user_rating ASC"
      else
        order = "created_at DESC"
    end

    case params[:things]
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
                                                            :category_id => params[:things].to_i },
                                           :include => :users
        @fragment = "submissions/submission"
    end

    respond_to do |format|
      format.html
    end
  end
end
