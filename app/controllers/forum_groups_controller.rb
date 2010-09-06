class ForumGroupsController < ApplicationController
  # GET /forum_groups
  # GET /forum_groups.xml
  def index
    @forum_groups = ForumGroup.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @forum_groups }
    end
  end

  # GET /forum_groups/1
  # GET /forum_groups/1.xml
  def show
    @forum_group = ForumGroup.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @forum_group }
    end
  end

  # GET /forum_groups/new
  # GET /forum_groups/new.xml
  def new
    @forum_group = ForumGroup.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @forum_group }
    end
  end

  # GET /forum_groups/1/edit
  def edit
    @forum_group = ForumGroup.find(params[:id])
  end

  # POST /forum_groups
  # POST /forum_groups.xml
  def create
    @forum_group = ForumGroup.new(params[:forum_group])

    respond_to do |format|
      if @forum_group.save
        format.html { redirect_to(forums_path, :notice => 'ForumGroup was successfully created.') }
        format.xml  { render :xml => @forum_group, :status => :created, :location => @forum_group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @forum_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /forum_groups/1
  # PUT /forum_groups/1.xml
  def update
    @forum_group = ForumGroup.find(params[:id])

    respond_to do |format|
      if @forum_group.update_attributes(params[:forum_group])
        format.html { redirect_to(forums_path, :notice => 'ForumGroup was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @forum_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /forum_groups/1
  # DELETE /forum_groups/1.xml
  def destroy
    @forum_group = ForumGroup.find(params[:id])
    @forum_group.destroy

    respond_to do |format|
      format.html { redirect_to(forum_groups_url) }
      format.xml  { head :ok }
    end
  end
  
  protected
  
  def admin_authority_required?
    %w(new create edit update destroy).include?(action_name)
  end

end
