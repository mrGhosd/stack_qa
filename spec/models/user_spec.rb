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
end