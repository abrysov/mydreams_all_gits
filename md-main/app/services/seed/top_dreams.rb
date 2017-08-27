module Seed
  class TopDreams
    def self.call(number_creates)
      number_creates.times do
        with_photo = [true, false].sample
        photo = Seed::RandomImage.call if with_photo

        TopDream.create(
          title: Faker::Lorem.sentence(5),
          photo: photo,
          description: Faker::Lorem.sentence
        )
      end
    end
  end
end
