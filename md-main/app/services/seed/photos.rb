module Seed
  class Photos
    def self.call(dreamer, number_creates)
      number_creates.times do
        dreamer.photos.create(
          file: Seed::RandomImage.call,
          caption: Faker::Lorem.sentence
        )
      end
    end
  end
end
