class Widget

  def self.switch_view(current_filter, direction)
    hash = Hash[hash_values.map.with_index.to_a]
  end

  def self.last_created
    Question.order("created_at DESC").first(5)
  end

  def self.best_answer

  end

  def self.best_comment

  end

  private

  def hash_values
    ["last_created", "best_answer", "best_comment"]
  end
end