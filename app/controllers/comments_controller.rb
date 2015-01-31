class CommentsController < ApplicationController
  def new
    @question = Question.find(params[:question_id])
    @comment = Comment.new(user: current_user, question: @question)
    render template: "comments/new", layout: false
  end

  def create
    comment = Comment.new(comment_params)
    if comment.save
      PrivatePub.publish_to "/questions/#{comment.question_id}/comments", comment: comment.to_json
      render nothing: true
    else
      render json: comment.errors.to_json, status: :forbidden
    end
  end

  def edit
    @question = Question.find(params[:question_id])
    @comment = Comment.find(params[:id])
    render template: 'comments/edit', layout: false
  end

  def update
    comment = Comment.find(params[:id])
    if comment.update(comment_params)
      PrivatePub.publish_to "/questions/#{comment.question_id}/comments/edit", comment: comment.to_json
      render nothing: true
    else
      render json: comment.errors.to_json, status: :forbidden
    end
  end

  def destroy
    Comment.find(params[:id]).destroy
    head :ok
  end

  private
  def comment_params
    params.require(:comment).permit(:user_id, :question_id, :text)
  end
end