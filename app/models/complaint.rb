class Complaint < ActiveRecord::Base
  belongs_to :user
  belongs_to :complaintable, polymorphic: true, touch: true

  def parent
    case self.complaintable_type
      when "Question"
        Question.find(self.complaintable_id)
      when "Answer"
        Answer.find(self.complaintable_id)
      when "Comment"
        Comment.find(self.complaintable_id)
      else
        nil
    end
  end
end