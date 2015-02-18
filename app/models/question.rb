class Question < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  has_many :answers, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :question_users
  validates :title, :text, presence: true
  validates :title, uniqueness: true

  include QuestionsHelper

  scope :created_today, -> { where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day) }

  def questions_filter(param)

  end

  def self.widget_filter
    # {
    #     last_created: {title: "Последние созданные:", data: questions_filter()},
    #     most_commented: {title: "Самые комментируемые", data: },
    #     quick_confirmed:{title: "Быстро подтвержденные", data: }
    # }
  end

  def self.signed_users(question)
    question.question_users.each do |signin|
      user = User.find(signin.user_id)
      QuestionMailer.signed_users(user, question).deliver
    end
  end
end