class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :text, :user_id, :question_id, :created_at, :updated_at
  has_many :comments, as: :commentable
end
