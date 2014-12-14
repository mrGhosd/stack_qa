class User <ActiveRecord::Base
  has_many :questions
  has_many :answers

  validates :email, :password
  validates :email
end