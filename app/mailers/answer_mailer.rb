class AnswerMailer < ActionMailer::Base
  default from: "from@example.com"


  def author_notification(answer)
    @author = answer.question.user
    @user = answer.user
    @answer = answer
    @question = answer.question

    mail to: @author.email
  end
end
