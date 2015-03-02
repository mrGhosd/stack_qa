module ApplicationHelper
  def collection_key_helper_for(model)
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_s)
    "#{klass}/collection-#{count}-#{max_updated_at}"
  end

  def key_for_object(object)
    klass = object.class
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_s)
    "#{klass}/#{object.id}-#{max_updated_at}"
  end

  def username_for_comment(user)
    if user.surname && user.name
      "#{user.surname} #{user.name}"
    else
      "#{user.email}"
    end
  end
end
