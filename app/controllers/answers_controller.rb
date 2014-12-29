class AnswersController < ApplicationController
  def new
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(user_id: current_user.id)
    render template: 'answers/new', layout: false
  end

  def create
    answer = Answer.new(answers_params)
    if answer.save
      render json: answer.to_json
    else
      render json: answer.errors.to_json
    end
  end

  def edit

  end

  def update

  end

  def answers_params
    params.require(:answer).permit(:question_id, :user_id, :text)
  end
end