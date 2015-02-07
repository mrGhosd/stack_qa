class Api::V1::AnswersController < Api::ApiController

  def index
    question = Question.find(params[:question_id])
    render json: question.answers.to_json
  end

  def show
    answer = Answer.find(params[:id])
    render json: answer
  end
end