module QuestionsHelper
  def widget_filter
    {
        # last_created: {title: "Последние созданные:", data: questions_filter()},
        # most_commented: {title: "Самые комментируемые", data: },
        # quick_confirmed:{title: "Быстро подтвержденные", data: }
    }
  end

  def question_filter(keyword)
    case keyword
      when "last_created"
      when "most_commented"
      when "quick_confirmed"
    end
  end
end