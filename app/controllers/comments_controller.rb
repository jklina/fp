class CommentsController < ApplicationController
  before_filter :find_commentable

  def create
    @comment = @commentable.comments.build(params[:comment])
    @comment.user = current_user

    respond_to do |format|
      kontroller = @commentable.class.to_s.pluralize.downcase
      if @comment.save
        format.html { redirect_to :controller => kontroller, :action => "show", :id => @commentable }
      else
        format.html { render :controller => kontroller, :action => "show", :id => @commentable }
      end
    end
  end

  protected

  def authentication_required?
    true
  end

  def find_commentable
    klass = params[:commentable_type].capitalize.constantize
    @commentable = klass.find(params[:commentable_id])
  end
end
