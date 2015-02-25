module Rating
  def rate
    type = params[:answer_id].blank? ? "Question" : "Answer"
    object = type.eql?("Answer") ? Answer.find(params[:answer_id]) : Question.find(params[:question_id])
    if object.update_rating(current_user, params[:rate])
      render json: {rate: object.rate}, status: :ok
    else
      render json: object.errors.to_json, status: :forbidden
    end
  end

  private
end
