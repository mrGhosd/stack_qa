class Question < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  has_many :answers, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :question_users, dependent: :destroy
  has_many :taggings
  has_many :tags, through: :taggings
  validates :title, :text, presence: true
  validates :title, uniqueness: true
  validates :category_id, presence: true

  acts_as_taggable

  include ModelRate
  include QuestionsHelper

  scope :created_today, -> { where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day) }
  scope :top, -> { order(rate: :desc) }

  def self.signed_users(question)
    question.question_users.each do |signin|
      user = User.find(signin.user_id)
      QuestionMailer.signed_users(user, question).deliver
    end
  end

  def comments_sum
    comments = self.comments.count
    comments += self.answers.map{|c| c.comments.count }.inject{|sum, x| sum += x} unless self.answers.blank?
    comments
  end

  def comments_count
    self.comments.count
  end

  def tag_list
    self.tags.map(&:name).join(", ")
  end

  def tag_list=(names)
    self.tags = names.split(",").map do |n|
      ActsAsTaggableOn::Tag.where(name: n.strip).first_or_create!
    end
  end

  def self.filter_by(filter_param, order_param)
    self.first.touch(:updated_at)
    eval(filter_values[filter_param])
  end

  def humanized_date
    self.created_at.strftime("%H:%M:%S %d.%m.%Y")
  end

  def answers_count
    self.answers.count
  end

  def self.filter_values
    {
        "rate" => "(lambda { |param, order| order(param + ' ' + order) }).call(filter_param, order_param)",
        "new" => "(lambda { |order| order(created_at: order.to_sym).last(10) }).call(order_param)",
        "views" => "(lambda { |param, order| order(param + ' ' + order) }).call(filter_param, order_param)",
        "is_closed" => "(lambda { |param, order| order(param + ' ' + order) }).call(filter_param, order_param)",
        "per_week" => "(lambda { |order| where(created_at: '#{Date.today-1.week} 00:00:00'.to_date..'#{Date.today} 23:59:59'.to_date).order(created_at: order.to_sym) }).call(order_param)",
        "per_month" => "(lambda { |order| where(created_at: '#{Date.today-1.month} 00:00:00'.to_date..'#{Date.today} 23:59:59'.to_date).order(created_at: order.to_sym) }).call(order_param)"
    }
  end
end