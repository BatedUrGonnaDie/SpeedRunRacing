class EntrantCreateValidator < ActiveModel::Validator
  def validate(entrant_record)
    validate_entrant_record(entrant_record)
  end

  private

  def validate_entrant_record(entrant)
    entrant.errors[:base] << "You're in another active race!" if entrant.user.in_active_race?
  end
end
