ThinkingSphinx::Index.define :comment, with: :active_record do
  indexes text
  indexes commentable_type

  has user_id, created_at, updated_at
end