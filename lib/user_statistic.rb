module UserStatistic
  def answer_to_question
    if current_user.statistic.answer_rate(current_user, @answer)
      PrivatePub.publish_to "/users/#{current_user.id}/rate", statistic: current_user.statistic.as_json
    else
    end
  end

  def helpfull_callback

  end
end