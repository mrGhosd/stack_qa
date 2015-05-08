class Api::V1::CommentsController < Api::ApiController
  include ApiComments
  def index
    render json: entity.comments.as_json, status: :ok
  end

  def create
    binding.pry
    comment = entity.comments.new(comment_params)
    message = entity.class.to_s.eql?("Question") ? "/questions/#{params[:question_id]}/comments" :
        "/questions/#{params[:question_id]}/answers/comments/create"
    if comment.save
      PrivatePub.publish_to message, comment: comment.as_json(methods: [:author, :humanized_date])
      render json: comment.as_json, status: :ok
    else
      render json: comment.errors.to_json, status: :unprocessable_entity
    end
  end

  def update
    comment = Comment.find(params[:id])
    message = entity.class.to_s.eql?("Question") ? "/questions/#{comment.commentable_id}/comments/edit" :
        "/questions/#{Answer.find(comment.commentable_id).question.id}/answers/comments/edit"
    if comment.update(comment_params)
      PrivatePub.publish_to message, comment: comment.as_json(methods: [:author, :humanized_date])
      render json: comment.as_json(methods: [:author, :humanized_date]), status: :ok
    else
      render json: comment.errors.to_json, status: :unprocessable_entity
    end

  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
    render json: {success: true}, status: :ok
  end

  private

  def comment_params
    params.require(:comment).permit(:user_id, :text)
  end
end