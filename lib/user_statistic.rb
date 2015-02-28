module UserStatistic
  def answer_to_question
    if current_user.statistic.answer_rate(current_user, @answer)
      PrivatePub.publish_to "/users/#{current_user.id}/rate", statistic: current_user.statistic.as_json
    end
  end

  def rate_callback
    if current_user.statistic.callback_rate(current_user, @object, @rate)
      PrivatePub.publish_to "/users/#{current_user.id}/rate", statistic: current_user.statistic.as_json
    end
  end
end