class EntrantValidator < ActiveModel::Validator
  def validate(entrant_record)
    validate_entrant_record(entrant_record)
  end

  private

  def validate_entrant_record(entrant)
    return unless entrant.user.active_races.count > 1
    entrant.errors[:base] << 'Entrant in another active race!'
  end
end
