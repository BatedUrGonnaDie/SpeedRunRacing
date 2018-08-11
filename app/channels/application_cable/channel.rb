module ApplicationCable
  class Channel < ActionCable::Channel::Base
    delegate :ability, to: :connection
    # dont allow the clients to call those methods
    protected :ability

    def get_errors_sentence(record)
      record.errors.full_messages.to_sentence
    end
  end
end
