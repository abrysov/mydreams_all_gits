module Relations
  class SendFriendRequest
    attr_reader :sender, :receiver

    def initialize(from:, to:)
      @sender = from
      @receiver = to
    end

    def call
      return friends_already_error if friends_already?

      if counter_request_exists?
        return AcceptFriendRequest.call(receiver, sender)
      end

      if receiver.follows?(sender)
        return AcceptFriendRequest.call(sender, receiver)
      end

      request = FriendRequest.new sender: sender, receiver: receiver
      FriendRequest.transaction do
        request.save
        Relations::Follow.call sender, receiver
        add_feedback(request)
      end

      if request.persisted?
        Result::Success.new request
      else
        Result::Error.new request.errors.full_messages.join(', ')
      end
    end

    def self.call(*args)
      new(*args).call
    end

    private

    def add_feedback(request)
      Feed::Feedback::Create.call(
        initiator: sender,
        dreamer: receiver,
        resource: request,
        action: :friendship_requested
      )
    end

    def counter_request_exists?
      FriendRequest.where(sender: receiver, receiver: sender).exists?
    end

    def friends_already?
      sender.friends.include? receiver
    end

    def friends_already_error
      Result::Error.new I18n.t('relations.errors.friends_already')
    end
  end
end
