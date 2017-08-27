module Seed
  class Dreams
    def self.call(dreamer, number_creates)
      dream_photo = Rack::Test::UploadedFile.new(File.open('spec/fixtures/avatar.jpg'))
      fulfilled = [true, false].sample
      if fulfilled
        fulfilled_at = Time.now
        came_true = 't'
      end

      number_creates.times do
        dreamer.dreams.create(
          title: Faker::Lorem.sentence(5),
          photo: dream_photo,
          description: Faker::Lorem.sentence,
          fulfilled_at: fulfilled_at,
          came_true: came_true
        )
      end
    end
  end
end
