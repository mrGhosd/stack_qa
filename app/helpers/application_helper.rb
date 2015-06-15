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
    if object.try(:question).present?
      "#{object.question.class}/#{klass}/#{object.id}-#{max_updated_at}"
    else
      "#{klass}/#{object.id}-#{max_updated_at}"
    end
  end

  def key_for_nested_resource(parent, children)
    if children.blank?
      children_updated_at =   parent.class.count
    else
      children_updated_at =  children[0].class.maximum(:updated_at)
    end
    parent_updated_at = parent.class.maximum(:updated_at)
    "#{parent_updated_at} - #{parent.class}/#{parent.id}/#{children.count}- #{parent.comments.maximum(:updated_at)} - #{children_updated_at}"
    binding.pry
  end

  def username_for_comment(user)
    if user.surname && user.name
      "#{user.surname} #{user.name}"
    else
      "#{user.email}"
    end
  end
end
