module ModelRate
  def update_rating(user, rate)
    if user.has_voted?(self) && votes_are_same?(user, rate_value(rate))
      self.errors[:was_voted] << true
      false
    else
      binding.pry
      vote_exists?(user) ? update_vote(user, rate) : create_vote(user, calc_rate(rate))
      self.update(rate: calc_rate(rate))
    end
  end

  def rate_value(rate)
    rate.eql?("plus") ? 1 : -1
  end

  def votes_are_same?(user, value)
    vote = user.votes.find_by(vote_id:self.id, vote_type: self.class.to_s)
    if vote
      return vote.rate == value ? true : false if vote
      return vote.rate + value == 0 ? false : true unless vote.blank?
    else
      false
    end
  end

  def calc_rate(rate)
    self.rate + rate_value(rate)
  end


  def vote_exists?(user)
    user.votes.find_by(vote_id:self.id, vote_type: self.class.to_s).blank? ? false : true
  end

  def update_vote(user, rate)
    user.votes.find_by(vote_id:self.id, vote_type: self.class.to_s).update(rate: calc_rate(rate))
  end

  def create_vote(user, rate)
    Vote.create(user_id: user.id, vote_id: self.id, vote_type: self.class.to_s, rate: rate)
  end
end