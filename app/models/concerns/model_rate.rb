module ModelRate
  
  def update_rating(user, object, rate)
    if user_has_voted?(user, object, rate_value(rate))
      object.errors[:was_voted] << true
      false
    else
      object.update(rate: calc_rate(object, rate))
    end
  end

  def rate_value(rate)
    rate.eql?("plus") ? 1 : -1
  end

  def calc_rate(object, rate)
    if rate.eql? "plus"
      final_rate = object.rate += 1
    else
      final_rate = object.rate -= 1
    end
  end
end