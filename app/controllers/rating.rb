module Rating
  def rate
    binding.pry
    @question = Question.find(params[:question_id])
    if @question.update_rating(current_user, params[:rate])
      render json: {rate: @question.rate}, status: :ok
    else
      render json: @question.errors.to_json, status: :forbidden
    end
  end
end
