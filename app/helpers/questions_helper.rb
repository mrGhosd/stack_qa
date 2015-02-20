module QuestionsHelper
  def question_for_comment(comment)
    comment.commentable_type.constantize.find(comment.commentable_id).id
  end

  def search_label(classname)
    case classname.to_s
      when "Question"
        "Вопрос"
    end
  end

end