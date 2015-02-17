class AnswerWorker
  include Sidekiq::Worker

  def perform(answer)
    AnswerMailer.author_notification(answer).deliver
  end
end
