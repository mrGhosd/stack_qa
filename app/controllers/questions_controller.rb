class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :define_question, only: [:edit, :show, :update, :destroy]
  after_action :publish_question, only: :create

  respond_to :html
  respond_to :json, only: :create

  def index
    respond_with(@questions = Question.all)
  end

  def new
    @question = Question.new
  end

  def edit
  end

  def show
  end

  def create
    question = Question.new(question_params)
    if question.save
      PrivatePub.publish_to "/questions", question: question.to_json
      render nothing: true
    else
      render json: question.errors.to_json, status: :forbidden
    end
  end

  def update
    @question.update(question_params)
    respond_with(@question)
  end

  def destroy
    respond_with(@question.destroy)
    head :ok
  end

  private

  def publish_question
    PrivatePub.publish_to "/questions", question: question.to_json
  end

  def define_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :text, :user_id, :category_id)
  end
end