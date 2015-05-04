class Api::V1::CommentsController < Api::ApiController
  include ApiComments
  def index
    render json: entity.comments.as_json, status: :ok
  end
end