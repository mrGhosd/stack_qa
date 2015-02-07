class Api::V1::QuestionsController < Api::ApiController
  def index
    @questions = Question.all
    render json: @questions
  end
end