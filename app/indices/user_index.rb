ThinkingSphinx::Index.define :user, with: :active_record do
  indexes surname
  indexes name
  indexes email
  indexes date_of_birth
  indexes place_of_birth

  has created_at, updated_at
end