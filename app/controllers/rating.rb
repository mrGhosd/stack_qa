module Rating
  def rate
    type = params[:answer_id].blank? ? "Question" : "Answer"
    object = type.eql?("Answer") ? Answer.find(params[:answer_id]) : Question.find(params[:question_id])
    if update_rating(current_user, object, params[:rate])
      render json: {rate: object.rate}, status: :ok
    else
      render json: object.errors.to_json, status: :forbidden
    end
  end

  private



  def user_has_voted?(user, object, value)
    vote = user.votes.select{ |element| element.vote_id == object.id && element.vote_type == object.class.to_s }[0]

    if vote && vote.rate + value == 0
      vote.destroy
      return false
    end

    if vote
      true
    else
      Vote.create(user_id: user.id, vote_id: object.id, vote_type: object.class.to_s, rate: value)
      false
    end
  end


end
