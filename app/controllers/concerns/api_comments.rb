module ApiComments
  def entity
    type = params[:answer_id].present? ? "Answer" : "Question"
    @entity ||= type.constantize.find(params[:answer_id] || params[:question_id] )
  end
end