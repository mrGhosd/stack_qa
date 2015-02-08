class Api::V1::AnswersController < Api::ApiController

  def index
    question = Question.find(params[:question_id])
    render json: question.answers.to_json
  end

  def create
    answer = Answer.new(answers_params)
    if answer.save
      render json: answer, status: :ok
    else
      render json: answer.errors.to_json, status: :unprocessible_entity
    end
  end

  def show
    answer = Answer.find(params[:id])
    render json: answer
  end

  private

  def answers_params
    params.require(:answer).permit(:question_id, :user_id, :text)
  end
end