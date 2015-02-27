module UserStatistic
  def answer_to_question
    current_user.statistic.answer_rate(current_user, @answer)
  end
end