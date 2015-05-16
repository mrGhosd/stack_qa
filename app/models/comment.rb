class Comment <ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, polymorphic: true, touch: true
  has_many :complaints, as: :complaintable, dependent: :destroy
  
  validates :text, presence: true

  default_scope { order(created_at: :desc) }

  def question
    if self.commentable_type == "Question"
      Question.find(self.commentable_id)
    elsif self.commentable_type == "Answer"
      Answer.find(self.commentable_id).question
    end
  end

  def answer
    Answer.find(self.commentable_id) if self.commentable_type.eql?("Answer")
  end

  def author
    User.find(self.user_id).correct_naming
  end

  def humanized_date
    self.created_at.strftime("%H:%M:%S %d.%m.%Y")
  end
end