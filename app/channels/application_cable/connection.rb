module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      log_tag = current_user.try(:id) || SecureRandom.hex
      logger.add_tags 'ActionCable', log_tag
    end

    def ability
      @ability = Ability.new(current_user)
    end

    protected

    def find_verified_user
      if request.query_parameters[:access_token].present?
        access_token ||= Doorkeeper::AccessToken.by_token(request.query_parameters[:access_token])
        reject_unauthorized_connection unless access_token.includes_scope?(:websocket_sign_in)
        user = User.find_by(id: access_token.try(:resource_owner_id))
        reject_unauthorized_connection if user.nil?

        user
      else
        env['warden'].user
      end
    end
  end
end
