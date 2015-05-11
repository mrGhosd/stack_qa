module Rating
  def rate
    type = params[:answer_id].blank? ? "Question" : "Answer"
    @object = type.eql?("Answer") ? Answer.find(params[:answer_id]) : Question.find(params[:question_id])
    @rate = params[:rate]
    if @object.update_rating(current_user || current_resource_owner, params[:rate])
      rate_callback
      render json: {rate: @object.rate, action: params[:rate]}, status: :ok
    else
      render json: @object.errors.to_json, status: :forbidden
    end
  end
end
