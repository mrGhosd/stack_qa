class Question < ActiveRecord::Base
  belongs_to :user, touch: true
  belongs_to :category
  has_many :answers, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :question_users
  has_many :taggings
  has_many :tags, through: :taggings
  validates :title, :text, presence: true
  validates :title, uniqueness: true

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

  def tag_list
    self.tags.map(&:name).join(", ")
  end

  def tag_list=(names)
    self.tags = names.split(",").map do |n|
      ActsAsTaggableOn::Tag.where(name: n.strip).first_or_create!
    end
  end
end