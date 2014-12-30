class AnswersController < ApplicationController
  def new
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(user_id: current_user.id)
    render template: 'answers/new', layout: false
  end

  def create
    answer = Answer.new(answers_params)
    if answer.save
      render json: answer.to_json, status: 200
    else
      render json: answer.errors.to_json, status: :forbidden
    end
  end

  def edit
    @question = Question.find(params[:question_id])
    @answer = Answer.find(params[:id])
    render template: 'answers/edit', layout: false
  end

  def update
    answer = Answer.find(params[:id])
    if answer.update(answers_params)
      render json: answer.to_json, status: 200
    else
      render json: answer.errors.to_json, status: :forbidden
    end
  end

  def destroy
    answer = Answer.find(params[:id])
    answer.destroy
    head :ok
  end

  def answers_params
    params.require(:answer).permit(:question_id, :user_id, :text)
  end
end