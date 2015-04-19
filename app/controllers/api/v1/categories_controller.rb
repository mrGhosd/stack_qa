class Api::V1::CategoriesController < Api::ApiController
  # before_action :doorkeeper_authorize!

  def index
    categories = Category.all
    render json: categories.as_json, status: :ok
  end
end