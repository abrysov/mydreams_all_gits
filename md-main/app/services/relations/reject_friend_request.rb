module Relations
  class RejectFriendRequest
    attr_reader :sender, :receiver

    def initialize(sender, receiver)
      @sender = sender
      @receiver = receiver
    end

    def call
      request.destroy

      Result::Success.new
    end

    def self.call(*args)
      new(*args).call
    end

    private

    def request
      FriendRequest.find_by! sender: sender, receiver: receiver
    end
  end
end
