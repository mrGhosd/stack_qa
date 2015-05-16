class Complaint < ActiveRecord::Base
  belongs_to :user
  belongs_to :complaintable, polymorphic: true, touch: true

  def parent
    case self.commentable_type
      when "Question"
        Question.find(self.commentable_id)
      when "Answer"
        Answer.find(self.commentable_id)
      when "Comment"
        Comment.find(self.commentable_id)
      else
        nil
    end
  end
end