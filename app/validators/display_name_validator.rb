class DisplayNameValidator < ActiveModel::Validator
  def validate(user_record)
    validate_user_record(user_record)
  end

  private

  def validate_user_record(user)
    user.display_name = user.username if user.display_name.blank?
    user.display_name.strip!
    return if user.display_name.casecmp(user.username.downcase).zero?

    user.errors[:base] << 'Display name may only contain case differences from username.'
  end
end
