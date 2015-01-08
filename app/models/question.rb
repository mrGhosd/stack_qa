class Question < ActiveRecord::Base
  belongs_to :user
  has_many :answers
  has_many :comments
  validates :title, :text, presence: true
  validates :title, uniqueness: true
end