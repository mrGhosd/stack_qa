class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question

  validates :text, presence: true

  default_scope { order(created_at: :desc) }
end