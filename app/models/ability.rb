class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can [:create], Race if user.can_create_race?
    can [:enter], Race if user.can_enter_race?
    can [:kick], Entrant do |entrant|
      entrant.updated_at + 10.minutes < Time.now.utc && entrant.race.creator_id == user.id && !entrant.ready?
    end

    can [:update, :destroy], Doorkeeper::Application, owner_id: user.id
  end
end
