class Question < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  has_many :answers, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  validates :title, :text, presence: true
  validates :title, uniqueness: true

  include QuestionsHelper

  def questions_filter(param)

  end

  def self.widget_filter
    # {
    #     last_created: {title: "Последние созданные:", data: questions_filter()},
    #     most_commented: {title: "Самые комментируемые", data: },
    #     quick_confirmed:{title: "Быстро подтвержденные", data: }
    # }
  end
end