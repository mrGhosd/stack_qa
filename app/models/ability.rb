class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
      if user
        user.is_admin? ? admin_abilities : current_user_abilities
      else
        guest_abilities
      end
  end

  def guest_abilities
    can :read, :all
  end

  def current_user_abilities
    guest_abilities
    can :manage, [RedactorRailsDocumentUploader,
                  RedactorRailsPictureUploader,
                  RedactorRails::Document,
                  RedactorRails::Picture, RedactorRails::Asset]
    can [:sign_in_question, :rate], Question
    can [:create, :update, :destroy], [Question, Answer, Comment], user: user
    cannot [:create, :update, :destroy], Category
    can [:edit, :update], User, user: user
    can :read, User
  end

  def admin_abilities
    can :manage, :all
  end
end
