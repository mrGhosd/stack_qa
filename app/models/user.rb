class User <ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook]

  has_many :questions
  has_many :answers
  has_many :comments

  validates :email, :password, presence: true
  validates :email, uniqueness: true

  def is_admin?
    self.role == 'admin'
  end

  def self.find_for_oauth(param)

  end
end