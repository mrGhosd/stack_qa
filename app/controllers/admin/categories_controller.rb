class Admin::CategoriesController < AdminController

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  private
  def category_params
    params.require(:category).permit(:title, :description, :image)
  end
end