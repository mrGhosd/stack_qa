class Api::V1::AnswersController < Api::ApiController
  before_action :doorkeeper_authorize!, only: [:create]
  include Rating
  include UserStatistic

  def index
    question = Question.find(params[:question_id])
    render json: question.answers.as_json(methods: :user_name)
  end

  def create
    answer = Answer.new(answers_params)
    if answer.save
      PrivatePub.publish_to "/questions/#{answer.question_id}/answers", answer: answer.to_json
      Answer.delay.send_notification_to_author(answer)
      render json: answer.as_json(methods: :user_name), status: :ok
    else
      render json: answer.errors.to_json, status: :unprocessible_entity
    end
  end

  def show
    answer = Answer.find(params[:id])
    render json: answer
  end

  def helpfull
    answer = Answer.find(params[:id])
    question = answer.question
    if answer.is_helpfull || question.is_closed
      render nothing: true, status: :unprocessible_entity
    else
      answer.update(is_helpfull: true)
      question.update(is_closed: true)
     render json: {success: true}, status: :ok
    end
  end

  private

  def answers_params
    params.require(:answer).permit(:question_id, :user_id, :text)
  end
end