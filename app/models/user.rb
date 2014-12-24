class User <ActiveRecord::Base
  has_many :questions
  has_many :answers

  validates :email, :password, presence: true
  validates :email, uniqueness: true
end