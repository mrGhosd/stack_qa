class Comment <ActiveRecord::Base
  belongs_to :user, touch: true
  belongs_to :commentable, polymorphic: true, touch: true

  validates :text, presence: true

  default_scope { order(created_at: :desc) }

  def question
    if self.commentable_type == "Question"
      Question.find(self.commentable_id)
    elsif self.commentable_type == "Answer"
      Answer.find(self.commentable_id).question
    end
  end

  def author
    User.find(self.user_id).correct_naming
  end

  def humanized_date
    self.created_at.strftime("%H:%M:%S %d.%m.%Y")
  end
end