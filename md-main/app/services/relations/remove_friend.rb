module Relations
  class RemoveFriend
    attr_reader :dreamer, :friend

    def initialize(dreamer, friend)
      @dreamer = dreamer
      @friend = friend
    end

    def call
      return no_dreamer_error if no_dreamer?

      if @dreamer.friends_with? @friend
        friendship.with_lock do
          unsubscribe_friend
          friendship.destroy
        end
      elsif @dreamer.wants_to_friend? @friend
        friend_request.with_lock do
          friend_request.destroy
          unsubscribe_friend
        end
      else
        unsubscribe_friend
      end

      Result::Success.new
    end

    def self.call(*args)
      new(*args).call
    end

    private

    def friendship
      Friendship.find_by 'friendships.member_ids @> ARRAY[?, ?]', @dreamer.id, @friend.id
    end

    def friend_request
      FriendRequest.find_by sender_id: @dreamer.id, receiver_id: @friend.id
    end

    def unsubscribe_friend
      Relations::Unfollow.call dreamer, friend
    end

    def no_dreamer?
      dreamer.blank? || friend.blank?
    end

    def no_dreamer_error?
      Result::Error.new I18n.t('relations.errors.no_dreamer')
    end
  end
end
