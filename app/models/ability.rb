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
    can :filter, Question
  end

  def current_user_abilities
    guest_abilities
    can :manage, [RedactorRailsDocumentUploader,
                  RedactorRailsPictureUploader,
                  RedactorRails::Document,
                  RedactorRails::Picture, RedactorRails::Asset]
    can [:sign_in_question], Question
    can :rate, [Question, Answer]
    can :create, [Question, Answer, Comment]
    can :helpfull, Answer do |resource|
      resource.question.user_id == user.id
    end
    can [:edit, :update, :destroy], [Question, Answer, Comment], user: user
    cannot [:create, :update, :destroy], Category
    can [:edit, :update], User, user: user
    can :read, User
  end

  def admin_abilities
    can :manage, :all
  end
end
