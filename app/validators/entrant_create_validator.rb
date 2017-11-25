class EntrantCreateValidator < ActiveModel::Validator
  def validate(entrant_record)
    validate_entrant_record(entrant_record)
  end

  private

  def validate_entrant_record(entrant)
    entrant.errors[:base] << 'User in another active race!' if entrant.user.active_races.count + 1 > 1
  end
end
