class AnswersController < ApplicationController
  after_create :publish_create, only: :create
  after_create :publish_edit, only: :update
  after_create :publish_destory, only: :destroy
  before_action :find_answer, only: [:edit, :update, :destory]
  respond_to :html
  respond_to :json

  def new
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(user_id: current_user.id)
    render template: 'answers/new', layout: false
  end

  def create
    respond_with(@answer = Answer.new(answers_params))
  end

  def edit
  end

  def update
    respond_with(@answer.update(answers_params))
  end

  def destroy
    respond_with(@answer.destroy)
    head :ok
  end


  private

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def publish_create
    PrivatePub.publish_to "/questions/#{@answer.question_id}/answers", answer: @answer.to_json
  end

  def publish_edit
    PrivatePub.publish_to "/questions/#{@answer.question_id}/answers/edit", answer: @answer.to_json
  end

  def publish_destroy
    PrivatePub.publish_to "/questions/#{@answer.question_id}/answers/destroy", answer_id: params[:id]
  end

  def answers_params
    params.require(:answer).permit(:question_id, :user_id, :text)
  end
end