module UserStatistic
  def answer_to_question
    user = current_user || current_resource_owner
    if user.statistic.answer_rate(user, @answer)
      PrivatePub.publish_to "/users/#{user.id}/rate", statistic: user.statistic.as_json
    end
  end

  def rate_callback
    user = current_user || current_resource_owner
    if user.statistic.callback_rate(user, @object, @rate)
      PrivatePub.publish_to "/users/#{user.id}/rate", statistic: user.statistic.as_json
    end
  end
end