module ApplicationCable
  class Channel < ActionCable::Channel::Base
    def get_errors_sentence(record)
      record.errors.full_messages.join(', ')
    end
  end
end
