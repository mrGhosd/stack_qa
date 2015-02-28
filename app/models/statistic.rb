class Statistic < ActiveRecord::Base
  belongs_to :user

  def answer_rate(user, answer)
    common_rating = self.rate
    question = answer.question
    params = ActionController::Parameters.new
    answer_rate_params.each do |key, value|
      exec_param = eval(value[:value])
      if exec_param.call(answer, user)
        common_rating += value[:rate]
        params = params.merge({key => self.send(key) + 1})
      end
    end
    params = params.merge({rate: common_rating})
    params.each { |key, value| self.send("#{key}=", value) }
    self.save
  end

  def callback_rate(user, object, rate)
    params = ActionController::Parameters.new
    rate_callback_params.each do |key, value|
      exec_param = eval(value[:value])
      if exec_param.call(object, rate)
        self.rate += value[:rate]
        params = params.merge({key => self.send(key) + 1})
      end
    end
    params.each { |key, value| self.send("#{key}=", value) }
    self.save
  end

  private

  def answer_rate_params
    {
        answers_count: {value: "lambda { |answer, user| true }", rate: 1},
        first_answers_count: {value: "lambda {|answer, user| answer.question.answers.length == 1 && answer.question.answers.first.user_id == user.id}", rate: 1},
        first_self_answers_count: {value: "lambda {|answer, user| question.user_id == user.id && answer.question.answers.length == 1 && answer.question.answers.first.user_id == user.id}", rate: 3},
        self_answers_count: { value: "lambda { |answer, user| answer.user_id == answer.question.user_id }", rate: 2 }
    }
  end

  def rate_callback_params
    {
        questions_positive_rate_count: {value: "lambda { |object, rate| rate == 'plus' && object.class.to_s=='Question' }", rate: 2},
        questions_negative_rate_count: {value: "lambda { |object, rate| rate == 'minus' && object.class.to_s=='Question' }", rate: -2},
        answers_positive_rate_count: {value: "lambda { |object, rate| rate == 'plus' && object.class.to_s=='Answer' }", rate: 1},
        answers_negative_rate_count: {value: "lambda { |object, rate| rate == 'minus' && object.class.to_s=='Answer' }", rate: -1}
    }
  end
end