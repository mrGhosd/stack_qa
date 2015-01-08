class CommentsController < ApplicationController
  def new
    @question = Question.find(params[:question_id])
    @comment = Comment.new(user_id: current_user.id, question_id: @question.id)
    render template: "comments/new", layout: false
  end
end