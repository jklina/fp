class CategoriesController < ApplicationController
  before_filter :find_category, :only => [ :show, :edit, :update, :destroy ]

  def index
    @categories = Category.paginate :page => params[:page],
                                    :per_page => 15,
                                    :order => "title DESC"
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
    @category = Category.new
  end

  def create
    @category = Category.new(params[:category])

    respond_to do |format|
      if @category.save
        flash[:notice] = "Category was successfully created."
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
        flash[:notice] = 'Category was successfully updated.'
        format.html { redirect_to edit_category_url(@category) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @category.destroy

    respond_to do |format|
      flash[:notice] = 'Category was successfully deleted.'
      format.html { redirect_to categories_url }
	  end
  end

  protected

  def authentication_required?
    true
  end

  def authority_required?
    true
  end

  def find_category
    @category = Category.find(params[:id])
  end
end
