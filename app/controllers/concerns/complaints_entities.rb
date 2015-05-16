module ComplaintsEntities do
  def entity
    parent = if params[:comment_id].present?
               "Comment"
             elsif params[:answer_id].present?
               "Answer"
             else
               "Question"
             end
    @entity ||= parent.constantize.find(params[:comment_id] || params[:answer_id] || params[:question_id])
  end
end