class AnswerDecorator < Draper::Decorator
  include Draper::LazyHelpers
  delegate_all

  def delegate_user
    h.content_tag :div, class: "definitio_user" do
      if object.question.user
        user_url = user_path(object.question.user)
        user_name = if object.question.user.surname.blank? || object.question.user.name.blank?
                      object.question.user.email
                    else
                      "#{object.question.user.name} #{object.question.user.surname}"
                    end
      else
        user_name = "неизвестно"
        user_url = "#"
      end

      question = object.question.text.first(10)<<"..."
      text = "К вопросу #{link_to question, question_path(object.question)}
      пользователя #{link_to user_name, user_url}:".html_safe
    end
  end

end
