module QuestionsHelper
  def question_for_comment(comment)
    comment.commentable_type.constantize.find(comment.commentable_id).id
  end
end