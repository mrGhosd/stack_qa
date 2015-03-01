require 'rails_helper'

describe User do
  it { should have_many :questions }
  it { should have_many :answers }

  it { should validate_presence_of :email }
  it { should validate_uniqueness_of :email }
  it { should validate_presence_of :password }

  it { should have_db_index :email }
  it { should have_db_index :password }

  let!(:user) { create :user }
  let!(:admin) { create :user, email: 'sokol.v93@mail.ru', role: 'admin' }

  describe "#is_admin?" do
    it "return true if user's role is 'admin'" do
      expect(user.is_admin?).to eq(false)
      expect(admin.is_admin?).to eq(true)
    end
  end

  describe ".from_omniauth(auth)" do
    let!(:user) { create :user }
    let!(:auth) { OmniAuth::AuthHash.new(provider: "facebook", uid: "12345") }

    context "user has already authorized" do
      it 'return the user' do
        user.authorizations.create(provider: "facebook", uid: "12345")
        expect(User.from_omniauth(auth)).to eq(user)
      end
    end

    context "user has no authorization" do
      let!(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: {email: user.email}) }

      it "doesn't create a user" do
        expect{User.from_omniauth(auth)}.to_not change(User, :count)
      end

      it 'creates authorization for user' do
        expect{ User.from_omniauth(auth).to change(user.authorizations, :count).by(1) }
      end

      it 'creates authorization with provider and uid' do
        user = User.from_omniauth(auth)
        authorization = user.authorizations.first

        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end

      it 'returns the user' do
        expect(User.from_omniauth(auth)).to eq(user)
      end
    end

    context 'user does not exists' do
      let!(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: {email: 'new@user.com'}) }

      it 'creates new user' do
        expect{ User.from_omniauth(auth) }.to change(User, :count).by(1)
      end

      it 'returns new user' do
        expect(User.from_omniauth(auth)).to be_a(User)
      end

      it 'fills user email' do
        user = User.from_omniauth(auth)
        expect(user.email).to eq(auth.info.email)
      end

      it 'creates authorization for user' do
        user = User.from_omniauth(auth)
        expect(user.authorizations).to_not be_empty
      end

      it 'creates authorization with provider and uid' do
        authorization = User.from_omniauth(auth)
      end
    end
  end

  describe "#correct_naming" do
    context "user doesn't have filled-in fields name and surname" do
      let!(:user) { create :user, name: nil, surname: nil }
      it "return an user email" do
        expect(user.correct_naming).to eq user.email
      end
    end

    context "user have filled-in fields name and usrname" do
      let!(:user) { create :user}
      it "return an user surname and name" do
        expect(user.correct_naming).to eq "#{user.surname} #{user.name}"
      end
    end
  end

  describe "#rate" do
    let!(:user){ create :user }
    let!(:statistic) { create :statistic, user_id: user.id }

    it "return user's current rate" do
      expect(user.rate).to eq(user.statistic.rate)
    end
  end

end