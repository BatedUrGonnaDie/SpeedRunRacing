module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      log_tag = current_user.try(:id) || SecureRandom.hex
      logger.add_tags 'ActionCable', log_tag
    end

    protected

    def find_verified_user
      env['warden'].user
    end
  end
end
