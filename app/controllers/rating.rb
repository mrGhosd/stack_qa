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

  def update_rating(user, object, rate)
    if user_has_voted?(user, object, rate_value(rate))
      object.errors[:was_voted] << true
      false
    else
      object.update(rate: calc_rate(object, rate))
    end
  end

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

  def rate_value(rate)
    rate.eql?("plus") ? 1 : -1
  end

  def calc_rate(object, rate)
    if rate.eql? "plus"
      final_rate = object.rate += 1
    else
      final_rate = object.rate -= 1
    end
  end
end
