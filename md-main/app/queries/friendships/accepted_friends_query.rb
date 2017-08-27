# TODO: remove after migration to new friendship schema
module Friendships
  class AcceptedFriendsQuery
    attr_accessor :dreamer

    def initialize(dreamer)
      @dreamer = dreamer
    end

    def call
      if (ids = friends_with_indices) == '0,0'
        Dreamer.none
      else
        Dreamer.joins('JOIN (values (' + ids + ')) as x (id, ordering) on dreamers.id = x.id').order('x.ordering DESC')
      end
    end

    def self.call(*args)
      new(*args).call
    end

    private

    def friends_with_indices
      ids = dreamer.all_accepted_friends_ids
      return '0,0' if ids.blank?

      ids.each_with_index.map { |e,i| [e,i].join(',') }.join('),(')
    end
  end
end
