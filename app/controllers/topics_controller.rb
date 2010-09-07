class TopicsController < ApplicationController
  
  before_filter :find_forum, :only => [ :new, :create, :edit, :update, :show ]
  before_filter :find_topic, :only => [ :destroy, :edit, :update, :show ]
  
  # GET /topics
  # GET /topics.xml
  def index
    @topics = Topic.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @topics }
    end
  end

  # GET /topics/1
  # GET /topics/1.xml
  def show
    @topic = Topic.find(params[:id])
    @post = @topic.posts.build
    @posts = @topic.posts(:order => "created_at ASC")
    
    @topic.view += 1
    @topic.save!

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @topic }
    end
  end

  # GET /topics/new
  # GET /topics/new.xml
  def new
    @topic = @forum.topics.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @topic }
    end
  end

  # GET /topics/1/edit
  def edit
  end

  # POST /topics
  # POST /topics.xml
  def create
    @topic = @forum.topics.build(params[:topic])
    @topic.user = current_user

    respond_to do |format|
      if @topic.save
        format.html { redirect_to(forum_topic_path(@topic.forum, @topic), :notice => 'Topic was successfully created.') }
        format.xml  { render :xml => @topic, :status => :created, :location => @topic }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @topic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /topics/1
  # PUT /topics/1.xml
  def update
    respond_to do |format|
      if @topic.update_attributes(params[:topic])
        format.html { redirect_to(forum_topic_path(@topic.forum, @topic), :notice => 'topic was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @topic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.xml
  def destroy
    @topic.destroy

    respond_to do |format|
      format.html { redirect_to(topics_url) }
      format.xml  { head :ok }
    end
  end
  
  protected
  
  def authentication_required?
    !%w(index show).include?(action_name)
  end
  
  def authority_required?
    %w(edit update destroy new create).include?(action_name)
  end
  
  def find_forum
    @forum = Forum.find(params[:forum_id])
  end
  
  def find_topic
    @topic = @forum.topics.find(params[:id])
  end
end
