# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
   if user.admin?
    can :manage, :all
   elsif user.client?
    can :read, :all
   end
  end
end
