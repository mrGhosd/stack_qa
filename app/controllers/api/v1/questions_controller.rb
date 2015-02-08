class Api::V1::QuestionsController < Api::ApiController
  def index
    @questions = Question.all
    render json: @questions
  end

  def create
    question = Question.new(question_params)
    if question.save
      render json: question.to_json
    else
      render json: question.errors.to_json
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :text, :user_id, :category_id)
  end
end