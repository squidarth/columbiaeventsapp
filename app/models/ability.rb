class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :all

    if user
      can :read, :all
      can :manage, :all if user.admin?

      # User
      can :update, User, id: user.id

      # Group
      can :create, Group
      can :manage, Group, users: { id: user.id }

      # Event
      can [:create, :fetch_from_facebook], Event
      can :manage, Event, user_id: user.id
    end
  end
end
