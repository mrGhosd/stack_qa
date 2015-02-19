class Vote < ActiveRecord::Base
  belongs_to :user

  scope :questions, -> { where(vote_type: "Question") }
  scope :answers, -> { where(vote_type: "Answer") }
end