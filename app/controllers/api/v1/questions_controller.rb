class Api::V1::QuestionsController < Api::ApiController
  def index
    questions = Question.all
    render json: questions.as_json
  end

  def create
    question = Question.new(question_params)
    if question.save
      render json: question.to_json, status: :ok
    else
      render json: question.errors.to_json, status: :uprocessible_entity
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :text, :user_id, :category_id)
  end
end