class CommentsController < ApplicationController

  def create
    if params[:type] == "Question"
      comment = Question.find(params[:question_id]).comments.new(comment_params.merge({user: current_user}))
      message = "/questions/#{params[:question_id]}/comments"
    elsif params[:type] == "Answer"
      comment = Question.find(params[:question_id]).answers.find(params[:answer_id]).comments.new(comment_params.merge({user: current_user}))
      message = "/questions/#{params[:question_id]}/answers/comments/create"
    end

    if comment.save
      PrivatePub.publish_to message, comment: comment.as_json(methods: [:author, :humanized_date])
      render nothing: true
    else
      render json: comment.errors.to_json, status: :unprocessible_entity
    end
  end

  def update
    comment = Comment.find(params[:id])
    if comment.update(comment_params)
      message = if comment.commentable_type == "Answer"
                  "/questions/#{Answer.find(comment.commentable_id).question.id}/answers/comments/edit"
                else
                  "/questions/#{comment.commentable_id}/comments/edit"
                end
      PrivatePub.publish_to message, comment: comment.as_json(methods: [:author, :humanized_date])
      render nothing: true
    else
      render json: comment.errors.to_json, status: :unprocessable_entity
    end
  end

  def destroy
    Comment.find(params[:id]).destroy
    head :ok
  end

  private

  def comment_params
    params.require(:comment).permit(:user_id, :text)
  end
end