class EntrantValidator < ActiveModel::Validator
  def validate(entrant_record)
    validate_entrant_record(entrant_record)
  end

  private

  def validate_entrant_record(entrant)
    if entrant.user.active_races.count > 1
      entrant.errors[:base] << 'User in another active race!'
    end

    # entrant.errors[:base] << 'User MUST link Twitch account to race.' if entrant.user.twitch_id.nil?
  end
end
