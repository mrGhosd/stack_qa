class Admin::CategoriesController < AdminController

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    category = Category.new(category_params)
    if category.save
      render json: {success: true}, status: :ok
    else
      render json: category.errors.to_json, status: :forbidden
    end
  end

  private
  def category_params
    params.require(:category).permit(:title, :description, :image)
  end
end