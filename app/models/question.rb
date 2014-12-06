class Question < ActiveRecord::Base
  belongs_to :user
  has_many :answers
  validates_presence_of :title, :text
  validates_uniqueness_of :title
end