class CommentsController < ApplicationController
  def new
    @question = Question.find(params[:question_id])
    if params[:type] ==  "Question"
      @entity = @question
      @comment = Comment.new(user: current_user, commentable_id: @entity, commentable_type: "Question")
    elsif params[:type] == "Answer"
      @entity = Answer.find(params[:answer_id])
      @comment = Comment.new(user: current_user, commentable_id: @entity.id, commentable_type: "Answer")
    end
    render template: "comments/new", layout: false
  end

  def create # Делать не просто комментарием, а создавать отосительно родительской сущности
    if params[:type] == "Question"
      comment = Question.find(params[:question_id]).comments.new(comment_params.merge({user: current_user}))
      message = "/questions/#{params[:question_id]}/comments"
    elsif params[:type] == "Answer"
      comment = Question.find(params[:question_id]).answers.find(params[:answer_id]).comments.new(comment_params.merge({user: current_user}))
      message = "/questions/#{params[:question_id]}/answers/comments/create"
    end
    if comment.save
      PrivatePub.publish_to message, comment: comment.to_json
      render nothing: true
    else
      render json: comment.errors.to_json, status: :unprocessible_entity
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
      render json: comment.errors.to_json, status: :unprocessible_entity
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