ThinkingSphinx::Index.define :question, with: :active_record do
  indexes title
  indexes text
  indexes answers.text, as: :answer
  indexes comments.text, as: :comment

  set_property enable_star: 1
  set_property min_infix_len: 1
end