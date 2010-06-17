class ThreadsController < ApplicationController
  # GET /threads
  # GET /threads.xml
  def index
    @threads = Thread.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @threads }
    end
  end

  # GET /threads/1
  # GET /threads/1.xml
  def show
    @thread = Thread.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @thread }
    end
  end

  # GET /threads/new
  # GET /threads/new.xml
  def new
    @thread = Thread.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @thread }
    end
  end

  # GET /threads/1/edit
  def edit
    @thread = Thread.find(params[:id])
  end

  # POST /threads
  # POST /threads.xml
  def create
    @thread = Thread.new(params[:thread])

    respond_to do |format|
      if @thread.save
        format.html { redirect_to(@thread, :notice => 'Thread was successfully created.') }
        format.xml  { render :xml => @thread, :status => :created, :location => @thread }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @thread.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /threads/1
  # PUT /threads/1.xml
  def update
    @thread = Thread.find(params[:id])

    respond_to do |format|
      if @thread.update_attributes(params[:thread])
        format.html { redirect_to(@thread, :notice => 'Thread was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @thread.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /threads/1
  # DELETE /threads/1.xml
  def destroy
    @thread = Thread.find(params[:id])
    @thread.destroy

    respond_to do |format|
      format.html { redirect_to(threads_url) }
      format.xml  { head :ok }
    end
  end
end
