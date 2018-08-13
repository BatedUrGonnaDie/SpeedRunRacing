class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can [:create], Race if user.can_create_race?
    can [:enter], Race if user.can_enter_race?
    can [:manage_inactive_users], Race, creator_id: user.id

    can [:update, :destroy], Doorkeeper::Application, owner_id: user.id
  end
end
