class QuestionMailer < ActionMailer::Base
  default from: "from@example.com"

  def signed_users(user, question)
    @question = question
    @user = user
    mail to: user.email
  end
end
