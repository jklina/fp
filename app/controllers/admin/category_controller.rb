class Admin::CategoryController < Admin::BaseController

  before_filter :find_category, :only => [ :show, :edit, :update, :destroy ]

  def index
    list
    render :action => 'list'
  end

  def list
    @categories = Category.paginate :page => params[:page], :per_page => 15, :order => 'title DESC'
  end

  def show
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(params[:category])
    if @category.save
      flash[:notice] = 'Category was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @category.update_attributes(params[:category])
      flash[:notice] = 'Category was successfully updated.'
      redirect_to :action => 'show', :id => @category
    else
      render :action => 'edit'
    end
  end

  def destroy
    if @category.destroy
	  flash[:notice] = 'Category was successfully deleted.'
      redirect_to :action => 'list'
	else
	  flash[:warning] = 'There was a problem saving your category'
	  redirect_to :action => 'list'
	end
  end
  
  protected
  
  def find_category
    @category = Category.find(params[:id])
  end
end
