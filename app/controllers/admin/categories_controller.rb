class Admin::CategoriesController < AdminController


  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    category = Category.new(category_params)
    respond_to do |format|
      if category.save
        format.html { redirect_to admin_categories_path }
        format.json { render json: category, status: :ok }
      else
        format.html { render 'new', status: :forbidden }
        format.json { render json: category.errors.to_json, status: :forbidden }
      end
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  private
  def category_params
    params.require(:category).permit(:title, :description, :image)
  end
end