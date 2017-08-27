module Relations
  class AcceptFriendRequest
    attr_reader :sender, :receiver

    def initialize(sender, receiver)
      @sender = sender
      @receiver = receiver
    end

    def call
      friendship = Friendship.new member_ids: [sender.id, receiver.id]

      Friendship.transaction do
        request.destroy unless receiver_follower?
        subscribe_reciever
        friendship.save!
        add_feedback_for(friendship)
        create_activity
      end
      Result::Success.new
    end

    def self.call(*args)
      new(*args).call
    end

    private

    def request
      FriendRequest.find_by! sender: sender, receiver: receiver
    end

    def receiver_follower?
      receiver.follows?(sender)
    end

    def subscribe_reciever
      Relations::Follow.call receiver, sender
    end

    def create_activity
      Feed::Activity::Create.call(owner: receiver,
                                  trackable: sender,
                                  key: 'friendship_accept')
    end

    def add_feedback_for(friendship)
      Feed::Feedback::Create.call(
        initiator: receiver,
        dreamer: sender,
        resource: friendship,
        action: :friendship_accept
      )
    end
  end
end
