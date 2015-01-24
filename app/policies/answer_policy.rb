class AnswerPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def update?
    user.is_admin? || user == record.user
  end

  def new?
    user.try(:is_admin?) || user
  end

  def create?
    user.try(:is_admin?) || user
  end

  def edit?
    user.try(:is_admin?) || user == record.user
  end

  def destroy?
    user.try(:is_admin?) || user == record.user
  end

  def index?
    user || user.try(:is_admin?) || nil
  end
end
