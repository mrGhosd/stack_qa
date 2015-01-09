class CommentsController < ApplicationController

  def new
    @question = Question.find(params[:question_id])
    @comment = Comment.new(user_id: current_user.id, question_id: @question.id)
    render template: "comments/new", layout: false
  end

  def create
    comment = Comment.new(comment_params)
    if comment.save
      render json: comment.to_json, status: :ok
    else
      render json: comment.errors.to_json, status: :forbidden
    end
  end

  def edit
    @question = Question.find(params[:question_id])
    @comment = Comment.find(params[:id])
    render template: 'comments/edit', layout: false
  end

  private
  def comment_params
    params.require(:comment).permit(:user_id, :question_id, :text)
  end
end