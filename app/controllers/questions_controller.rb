class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :define_question, only: [:edit, :show, :update, :destroy]

  def index
    @questions = Question.all
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
      render json: {success: true}, status: :ok
    else
      render json: question.errors.to_json, status: :forbidden
    end
  end

  def update
    if @question.update(question_params)
      redirect_to question_path(@question)
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    head :ok
  end

  private
  def define_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :text, :user_id)
  end
end