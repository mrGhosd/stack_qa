class Admin::CategoriesController < AdminController

  def index
    @categories = Category.all
  end

  def new

  end
end