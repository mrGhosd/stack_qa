module ModelRate
  def update_rating(user, rate)
    if user.has_voted?(self) && votes_are_same?(user, rate_value(rate))
      self.errors[:was_voted] << true
      false
    else
      vote_exists?(user) ? destroy_vote(user, rate) : create_vote(user, calc_rate(rate), rate)
      self.update(rate: calc_rate(rate))
    end
  end

  def rate_value(rate)
    rate.eql?("plus") ? 1 : -1
  end

  def votes_are_same?(user, value)
    action = value == 1 ? "plus" : "minus"
    vote = user.votes.find_by(vote_id:self.id, vote_type: self.class.to_s)
    if vote
      if vote.vote_value == action
        return true
      else
        return false
      end
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

  def destroy_vote(user, rate)
    user.votes.find_by(vote_id:self.id, vote_type: self.class.to_s).destroy
  end

  def update_vote(user, rate)
    user.votes.find_by(vote_id:self.id, vote_type: self.class.to_s).update(vote_value: rate, rate: calc_rate(rate))
  end

  def create_vote(user, rate, vote_action)
    Vote.create(user_id: user.id, vote_id: self.id, vote_value: vote_action, vote_type: self.class.to_s, rate: rate)
  end
end