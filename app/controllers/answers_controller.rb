class AnswersController < ApplicationController
  include Rating
  include UserStatistic

  after_action :answer_to_question, only: :create
  before_action :sanitaze_text, only: [:create, :update]

  def new
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(user_id: current_user.id)
    render template: 'answers/new', layout: false
  end

  def create
    @answer = Answer.new(answers_params)
    if @answer.save
      PrivatePub.publish_to "/questions/#{@answer.question_id}/answers", answer: @answer.to_json
      Answer.delay.send_notification_to_author(@answer)
      render nothing: true
    else
      render json: @answer.errors.to_json, status: :unprocessable_entity
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
      PrivatePub.publish_to "/questions/#{answer.question_id}/answers/edit", answer: answer.to_json
      render nothing: true
    else
      render json: answer.errors.to_json, status: :unprocessable_entity
    end
  end

  def helpfull
    answer = Answer.find(params[:id])
    question = answer.question
    if answer.is_helpfull || question.is_closed
      head :unprocessible_entity
    else
      answer.update(is_helpfull: true)
      question.update(is_closed: true)
      head :ok
    end
  end

  def destroy
    answer = Answer.find(params[:id])
    PrivatePub.publish_to "/questions/#{answer.question_id}/answers/destroy", answer_id: params[:id]
    answer.destroy
    head :ok
  end

  private
  def answers_params
    params.require(:answer).permit(:question_id, :user_id, :text)
  end

  def sanitaze_text
    params[:answer][:text] = ActionView::Base.full_sanitizer.sanitize(params[:answer][:text])
  end
end