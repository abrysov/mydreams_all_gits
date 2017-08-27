module Seed
  class Subscriptions
    def self.call(dreamer, number_creates)
      number_creates.times do
        to_subscribe = Dreamer.where('id NOT IN (?)', dreamer.id).order('random()').first

        Relations::Follow.call dreamer, to_subscribe
      end
    end
  end
end
