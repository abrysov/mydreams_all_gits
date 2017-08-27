module Relations
  class Unfollow
    attr_reader :dreamer, :followee

    def initialize(dreamer, followee)
      @dreamer = dreamer
      @followee = followee
    end

    def call
      return no_dreamer_error if no_dreamer?

      if dreamer.follows? followee
        unsubscribe_followee
        remove_followee_friend_request
        Result::Success.new
      else
        Result::Error.new
      end
    end

    def self.call(*args)
      new(*args).call
    end

    private

    def no_dreamer?
      dreamer.blank? || followee.blank?
    end

    def no_dreamer_error
      Result::Error.new I18n.t('relations.errors.no_dreamer')
    end

    def unsubscribe_followee
      dreamer.unsubscribe(followee)
    end

    def remove_followee_friend_request
      return unless followee.wants_to_friend? dreamer

      Relations::RejectFriendRequest.call(followee, dreamer)
    end
  end
end
