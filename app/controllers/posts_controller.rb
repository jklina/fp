class PostsController < ApplicationController
  # GET /posts
  # GET /posts.xml
  
  before_filter :find_topic, :only => [ :new, :create, :edit, :update, :show ]
  before_filter :find_post, :only => [ :destroy, :edit, :update, :show ]
  
  def index
    @posts = Post.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
    @post = @topic.posts.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.xml
  def create
    @post = @topic.posts.build(params[:post])
    @post.user = current_user
    @topic.forum.posts << @post

    respond_to do |format|
      if @post.save
        format.html { redirect_to(forum_topic_path(@topic.forum, @topic), :notice => 'Post was successfully created.') }
        format.xml  { render :xml => @topic, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to(@post, :notice => 'Post was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to(posts_url) }
      format.xml  { head :ok }
    end
  end
  
  protected
  
  def authentication_required?
    !%w(index show).include?(action_name)
  end
  
  def find_forum
    @forum = Forum.find(params[:forum_id])
  end
  
  def find_topic
    @topic = Topic.find(params[:topic_id])
  end
  
  def find_post
    post = @topic.posts.find(params[:id])
  end
end
