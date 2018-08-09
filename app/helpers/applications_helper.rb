module ApplicationsHelper
  def scope_to_sentence(scope)
    case scope
    when 'websocket_sign_in'
      'Create, enter, and leave races on your behalf'
    end
  end
end
