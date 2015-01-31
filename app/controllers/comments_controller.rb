class CommentsController < ApplicationController
  def new
    @question = Question.find(params[:question_id])
    if params[:type] ==  "Question"
      @entity = @question
      @comment = Comment.new(user: current_user, commentable_id: @entity, commentable_type: "Question")
    elsif params[:type] == "Answer"
      # binding.pry
      @entity = Answer.find(params[:answer_id])
      @comment = Comment.new(user: current_user, commentable_id: @entity.id, commentable_type: "Answer")
    end
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
    params.require(:comment).permit(:user_id, :commentable_id, :commentable_type, :text)
  end
end