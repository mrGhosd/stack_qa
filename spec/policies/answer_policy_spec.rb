require 'rails_helper'

describe AnswerPolicy do
  let(:user) { create :user }

  subject { AnswerPolicy }

  permissions :update? do
    it "grant access if user is admin" do
      expect(subject).to permit(User.new(role: 'admin'), create(:answer))
    end

    it "grant access if user is author" do
      expect(subject).to permit(user, create(:answer, user: user))
    end

    it "denied access if user is not author" do
      expect(subject).to_not permit(User.new, create(:answer, user: user))
    end
  end

  permissions :new? do
    it "grant access if user is log in" do
      expect(subject).to permit(user, create(:answer))
    end

    it "grant access if user is admin?" do
      expect(subject).to permit(User.new(role: 'admin'), create(:answer))
    end

    it "denied access if user is not log in" do
      expect(subject).to_not permit(nil, create(:answer))
    end
  end

  permissions :create? do
    it "grant access if user is log in" do
      expect(subject).to permit(user, create(:answer))
    end

    it "grant access if user is admin?" do
      expect(subject).to permit(User.new(role: 'admin'), create(:answer))
    end

    it "denied access if user is not log in" do
      expect(subject).to_not permit(nil, create(:answer))
    end
  end

  permissions :edit? do
    it "grant access if user is admin?" do
      expect(subject).to permit(User.new(role: 'admin'), create(:answer))
    end

    it "grant access if user is author" do
      expect(subject).to permit(user, create(:answer, user: user))
    end

    it "denied access if user is not author" do
      expect(subject).to_not permit(User.new, create(:answer, user: user))
    end
  end
end