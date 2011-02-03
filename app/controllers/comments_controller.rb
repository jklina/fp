class CommentsController < ApplicationController
  before_filter :find_commentable, :except => [:destroy]

  def create
    @comment = @commentable.comments.build(params[:comment])
    
    @comment.user = current_user

    respond_to do |format|
      kontroller = @commentable.class.to_s.pluralize.downcase
      if @comment.save
        format.html { redirect_to :controller => kontroller, :action => "show", :id => @commentable }
      else
        format.html { render :action => "#{kontroller}/show", :id => @commentable }
      end
    end
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      flash[:notice] = "Comment deleted."
      #hack to redirect back
      format.html { redirect_to :back}
	  end
  end

  protected

  def authentication_required?
    true
  end
  
  def authority_required?
    %w(destroy).include?(action_name)
  end

  def find_commentable
    klass = params[:commentable_type].capitalize.constantize
    @commentable = klass.find(params[:commentable_id])
  end
end
