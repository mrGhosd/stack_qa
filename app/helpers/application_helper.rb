module ApplicationHelper
  def collection_key_helper_for(model)
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_s)
    "#{klass}/collection-#{count}-#{max_updated_at}"
  end
end
