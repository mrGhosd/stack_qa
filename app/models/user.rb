class User <ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook]

  has_many :authorizations
  has_many :questions
  has_many :answers
  has_many :comments

  validates :email, :password, presence: true
  validates :email, uniqueness: true

  def is_admin?
    self.role == 'admin'
  end

  def self.from_omniauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization
    email = auth.info.email
    user = User.find_by email: email
    user.authorizations.create(provider: auth.provider, uid: auth.uid.to_s) if user
  end
end