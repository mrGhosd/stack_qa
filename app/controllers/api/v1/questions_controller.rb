class Api::V1::QuestionsController < Api::ApiController
  before_action :doorkeeper_authorize!, only: :create
  include UserStatistic
  include Rating

  def index
    questions = Question.paginate(page: params[:page] || 1, per_page: 20).top
    render json: questions.as_json(methods: [:answers_count, :comments_count, :tag_list])
  end

  def create
    question = Question.new(question_params)
    if question.save
      PrivatePub.publish_to "/questions", question: question.as_json(methods: [:humanized_date, :answers_count, :comments_sum])
      render json: question.to_json, status: :ok
    else
      render json: question.errors.to_json, status: :uprocessible_entity
    end
  end

  def update
    binding.pry
    question = Question.find(params[:id])
    if question.update(question_params)
      render json: question.to_json, status: :ok
    else
      render json: question.errors.to_json, status: :uprocessable_entity
    end
  end

  def show
    question = Question.find(params[:id])
    current_user_voted = {"current_user_voted" => current_resource_owner.vote_on_question(question) }
    render json: question.as_json(methods: [:tag_list, :category, :user, :answers_count, :comments_count]).merge(current_user_voted)
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