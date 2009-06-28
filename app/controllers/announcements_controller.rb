class AnnouncementsController < ApplicationController
  before_filter :find_announcement, :except => [ :index, :new, :create ]

  def index
    @announcements = Announcement.paginate :page => params[:page],
                                           :per_page => 16,
                                           :order => "created_at DESC"

    respond_to do |format|
      format.html
    end
  end

  def show
    respond_to do |format|
      format.html
    end
  end

  def new
    @announcement = Announcement.new
  end

  def create
    @announcement = Announcement.new(params[:announcement])
    @announcement.user = current_user

    respond_to do |format|
      if @announcement.save
        flash[:notice] = "Successfully published your announcement!"
        format.html { redirect_to announcements_url }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @announcement.update_attributes(params[:announcement])
        flash[:notice] = "Your changes were saved."
        format.html { redirect_to edit_announcement_url(@announcement) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @announcement.destroy
    
    respond_to do |format|
      format.html
    end
  end

  protected

  def authentication_required?
    %w(new create edit update destroy).include?(action_name)
  end

  def authority_required?
    %w(new create edit update destroy).include?(action_name)
  end

  def find_announcement
    @announcement = Announcement.find(params[:id])
  end
end
