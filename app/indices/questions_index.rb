ThinkingSphinx::Index.define :question, with: :active_record do
  indexes title
  indexes text
end