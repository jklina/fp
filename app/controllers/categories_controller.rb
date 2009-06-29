class CategoriesController < ApplicationController
  before_filter :find_category, :except => [ :index, :new, :create ]

  def index
    @categories = Category.find(:all)

    respond_to do |format|
      format.html
    end
  end

  def show
    @submissions = @category.submissions.paginate :page => params[:page],
                                                  :per_page => 16,
                                                  :order => "created_at DESC"

    respond_to do |format|
      format.html
    end
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(params[:category])

    respond_to do |format|
      if @category.save
        flash[:notice] = "Successfully created your category!"
        format.html { redirect_to categories_url }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @category.update_attributes(params[:category])
        flash[:notice] = "Your changes were saved."
        format.html { redirect_to edit_category_url(@category) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @category.destroy

    respond_to do |format|
      flash[:notice] = "Category deleted."
      format.html { redirect_to categories_url }
	  end
  end

  protected

  def authentication_required?
    authority_required?
  end

  def authority_required?
    %w(new create edit update destroy).include?(action_name)
  end

  def find_category
    @category = Category.find(params[:id])
  end
end
