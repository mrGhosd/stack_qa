class Api::V1::CategoriesController < Api::ApiController
  # before_action :doorkeeper_authorize!

  def index
    categories = Category.paginate(page: params[:page] || 1, per_page: 5)
    render json: categories.as_json, status: :ok
  end

  def questions
    category = Category.find(params[:id])
    render json: category.questions.paginate(page: params[:page] || 1, per_page: 10).as_json(methods: [:answers_count, :comments_count, :tag_list]), status: :ok
  end

  def show
    category = Category.find(params[:id])
    render json: category.as_json, status: :ok
  end
end