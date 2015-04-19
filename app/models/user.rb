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
  has_many :votes
  has_one :statistic

  validates :email, presence: true
  validates :password, presence: true, on: :create
  validates :email, uniqueness: true

  after_create :create_statistic

  mount_uploader :avatar, AvatarUploader

  def is_admin?
    self.role == 'admin'
  end

  def correct_naming
    if self.surname && self.name
      "#{self.surname} #{self.name}"
    else
      "#{self.email}"
    end
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

  def rate
    self.statistic.rate
  end

  def questions_count
    self.questions.count
  end

  def answers_count
    self.answers.count
  end

  def comments_count
    self.comments.count
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid.to_s)
  end

  def self.send_daily_digest
    all.each do |user|
      DailyMailer.digest(user).deliver
    end
  end

  def has_voted?(object)
    vote = self.votes.find_by(vote_id: object.id, vote_type: object.class.to_s)
    vote ? true : false
  end

  private

  def create_statistic
    Statistic.create!(user_id: self.id)
  end
end