module Seed
  class Friends
    def self.call(dreamer, number_creates)
      number_creates.times do
        friend = Dreamer.where('id NOT IN (?)', dreamer.id).order('random()').first
        accepted = [true, false].sample
        accepted_at = Time.zone.now if accepted

        Friendship.create(
          dreamer: dreamer,
          friend: friend,
          member_ids: [dreamer.id, friend.id],
          accepted_at: accepted_at
        )
      end
    end
  end
end
