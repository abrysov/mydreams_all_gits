module Seed
  class Avatars
    def self.call(dreamer, number_creates)
      number_creates.times do
        dreamer.avatars.create(
          photo: Seed::RandomImage.call,
          crop_meta: 'test'
        )
      end
    end
  end
end
