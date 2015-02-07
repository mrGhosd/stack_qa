class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :text, :created_at, :updated_at, :short_title
  has_many :answers
  has_many :comments, as: :commentable

  def short_title
    object.title.truncate(10)
  end
end
