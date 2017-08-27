module Seed
  class Likes
    def self.call(dreamer, number_creates)
      number_creates.times do
        dreamer.likes.create(likeable: Seed::RandomEntity.call)
      end
    end
  end
end
