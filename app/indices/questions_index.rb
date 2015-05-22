ThinkingSphinx::Index.define :question, with: :active_record do
  indexes title
  indexes text
  indexes answers.text, as: :answer
  indexes comments.text, as: :comment
end