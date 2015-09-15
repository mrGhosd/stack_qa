module Api
  module V2
    class QuestionsController < Api::ApiController

      def show
        question = Question.includes(:comments, :category, :user, :tags).find(params[:id])
        current_user_voted = {"current_user_voted" => current_resource_owner.vote_on_question(question) } if current_resource_owner
        render json: question.as_json(methods: [:tag_list, :category, :user, :answers, :comments]).merge(current_user_voted || {})
      end
    end
  end
end