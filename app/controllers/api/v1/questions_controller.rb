require 'will_paginate/array'
class Api::V1::QuestionsController < Api::ApiController
  before_action :doorkeeper_authorize!, only: [:create, :update]
  include UserStatistic
  include Rating

  def index
    questions = Question.top.paginate(page: params[:page] || 1, per_page: 20)
    render json: questions.as_json(only: [:id, :user_id, :title, :views, :rate, :created_at], methods: [:answers_count, :comments_count])
  end

  def create
    question = Question.new(question_params)
    if question.save
      PrivatePub.publish_to "/questions", question: question.as_json(methods: [:humanized_date, :answers_count, :comments_sum])
      render json: question.to_json, status: :ok
    else
      render json: question.errors.to_json, status: :unprocessable_entity
    end
  end

  def update
    question = Question.find(params[:id])
    if question.update(question_params)
      render json: question.to_json, status: :ok
    else
      render json: question.errors.to_json, status: :uprocessable_entity
    end
  end

  def filter
    questions = Question.filter(params[:filter]).paginate(page: params[:page] || 1, per_page: 20)
    render json: questions.as_json(except: :tags, methods: [:answers_count, :comments_count, :tag_list])
  end

  def show
    question = Question.includes([:comments, :category, :user, :tags]).find(params[:id])
    current_user_voted = {"current_user_voted" => current_resource_owner.vote_on_question(question) } if current_resource_owner
    render json: question.as_json(methods: [:tag_list, :category, :user]).merge(current_user_voted || {})
  end

  def destroy
    question = Question.find(params[:id])
    question.destroy
    render json: {success: true}.to_json, status: :ok
  end

  private

  def question_params
    params.require(:question).permit(:title, :text, :user_id, :category_id, :tag_list)
  end
end