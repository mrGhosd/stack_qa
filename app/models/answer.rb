class Answer < ActiveRecord::Base
  belongs_to :user, touch: true
  belongs_to :question, touch: true
  has_many :comments, as: :commentable, dependent: :destroy
  include ModelRate
  validates :text, presence: true

  default_scope { order(created_at: :desc) }

  def self.send_notification_to_author(answer)
    AnswerMailer.author_notification(answer).deliver
  end

  def user_name
    self.user.correct_naming
  end

  def comments_count
    self.comments.count
  end
end