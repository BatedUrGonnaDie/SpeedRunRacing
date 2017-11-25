class EntrantAlwaysValidator < ActiveModel::Validator
  def validate(entrant_record)
    validate_entrant_record(entrant_record)
  end

  private

  def validate_entrant_record(entrant)
    # entrant.errors[:base] << 'User MUST link Twitch account to race.' if entrant.user.twitch_id.nil?
    entrant.errors[:base] << 'Entrant is disqualified' if entrant.place == Entrant::DISQUALIFIED
  end
end
