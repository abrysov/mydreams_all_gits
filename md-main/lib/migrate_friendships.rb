class MigrateFriendships
  def self.call
    Rails.logger.level = Logger::WARN

    Dreamer.find_each do |dreamer|
      # create friendships
      friends = Friendships::AcceptedFriendsQuery.call(dreamer)
      friends.find_each do |friend|
        ActiveRecord::Base.transaction do
          Subscription.where(subscriber: dreamer, dreamer: friend).first_or_create
          Subscription.where(subscriber: friend, dreamer: dreamer).first_or_create
          Friendship.where('member_ids @> ARRAY[?, ?]', friend.id, dreamer.id)
            .first_or_create(member_ids: [dreamer.id, friend.id])
        end
      end

      # create followers
      followers = dreamer.not_accepted_inverse_friendships.subscribings.map(&:dreamer)
      followers.each do |follower|
        unless dreamer.friends.include?(follower)
          Following.where(follower: follower, followee: dreamer).first_or_create
          Subscription.where(subscriber: follower, dreamer: dreamer).first_or_create
        end
      end

      # create friend requests
      pending_requests = dreamer.not_accepted_inverse_friendships.not_processed.not_subscribings.map(&:dreamer)
      pending_requests.each do |request|
        unless Following.where(follower: dreamer, followee: request).exists?
          Subscription.where(subscriber: request, dreamer: dreamer).first_or_create
          Following.where(follower: request, followee: dreamer).first_or_create
          FriendRequest.where(sender: request, receiver: dreamer).first_or_create
        end
      end

      Rails.logger.warn("finished #{dreamer.id}");
    end

    Rails.logger.level = Logger::INFO
  end
end
