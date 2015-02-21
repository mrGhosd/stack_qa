class Comment <ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :text, presence: true

  default_scope { order(created_at: :desc) }

  def question
    if self.commentable_type == "Question"
      Question.find(self.commentable_id)
    elsif self.commentable_type == "Answer"
      Answer.find(self.commentable_id).question
    end
  end
end