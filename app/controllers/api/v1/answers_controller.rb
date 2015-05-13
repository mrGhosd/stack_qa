class Api::V1::AnswersController < Api::ApiController
  before_action :doorkeeper_authorize!, only: [:create]
  include Rating
  include UserStatistic

  def index
    question = Question.includes(:answers).find(params[:question_id])
    render json: question.answers.paginate(page: params[:page] || 1, per_page: 10).as_json(methods: [:user_name, :comments_count])
  end

  def create
    answer = Answer.new(answers_params)
    if answer.save
      PrivatePub.publish_to "/questions/#{answer.question_id}/answers", answer: answer.to_json
      Answer.delay.send_notification_to_author(answer)
      render json: answer.as_json(methods: [:user_name, :comments_count]), status: :ok
    else
      render json: answer.errors.to_json, status: :unprocessable_entity
    end
  end

  def update
    answer = Answer.find(params[:id])
    if answer.update(answers_params)
      PrivatePub.publish_to "/questions/#{answer.question_id}/answers/edit", answer: answer.to_json
      render json: answer.as_json(methods: [:comments_count, :user_name]), status: :ok
    else
      render json: answer.errors.to_json, status: :unprocessable_entity
    end
  end

  def show
    answer = Answer.find(params[:id])
    render json: answer.as_json
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

  def destroy
    answer = Answer.find(params[:id])
    answer.question.update(is_closed: false) if answer.is_helpfull && answer.question.present?
    answer.destroy
    render json: {success: true}.to_json, status: :ok
  end

  private

  def answers_params
    params.require(:answer).permit(:question_id, :user_id, :text)
  end
end