class User <ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter]

  has_many :authorizations
  has_many :questions
  has_many :answers
  has_many :comments
  has_many :question_users

  validates :email, presence: true
  validates :password, presence: true, on: :create
  validates :email, uniqueness: true

  mount_uploader :avatar, AvatarUploader

  def is_admin?
    self.role == 'admin'
  end

  def self.from_omniauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization
    email = auth.info.email
    user = User.find_by email: email
    if user
      user.create_authorization(auth)
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.create_authorization(auth)
    end
    user
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid.to_s)
  end

  def self.send_daily_digest
    all.each do |user|
      DailyMailer.digest(user).deliver
    end
  end
end