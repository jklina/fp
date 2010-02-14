class StaticPagesController < ApplicationController

  before_filter :find_static_page, :except => [ :index, :show, :new, :create ]

  # GET /static_pages
  # GET /static_pages.xml
  def index
    @static_pages = StaticPage.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @static_pages }
    end
  end

  # GET /static_pages/1
  # GET /static_pages/1.xml
  def show
	@static_page = StaticPage.find_by_slug(params[:id], [ :user, { :comments => :user }])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @static_page }
    end
  end

  # GET /static_pages/new
  # GET /static_pages/new.xml
  def new
    @static_page = StaticPage.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @static_page }
    end
  end

  # GET /static_pages/1/edit
  def edit
  end

  # POST /static_pages
  # POST /static_pages.xml
  def create
    @static_page = StaticPage.new(params[:static_page])

    respond_to do |format|
      if @static_page.save
        flash[:notice] = "Page was successfully created."
        format.html { redirect_to(@static_page) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /static_pages/1
  # PUT /static_pages/1.xml
  def update

    respond_to do |format|
      if @static_page.update_attributes(params[:static_page])
        flash[:notice] = "Page was successfully updated."
        format.html { redirect_to(@static_page) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /static_pages/1
  # DELETE /static_pages/1.xml
  def destroy
    @static_page.destroy

    respond_to do |format|
      format.html { redirect_to(static_pages_url) }
    end
  end
  
  protected
  
  def authentication_required?
    !%w(show).include?(action_name)
  end

  def admin_authority_required?
    %w(index new create edit update destroy).include?(action_name)
  end
  
  def find_static_page
    @static_page = StaticPage.find_by_slug(params[:id])
  end
end
