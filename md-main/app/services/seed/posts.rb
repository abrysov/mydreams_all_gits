module Seed
  class Posts
    def self.call(dreamer, with_photo, number_creates)
      number_creates.times do
        post_photo = Seed::RandomImage.call if with_photo
        dreamer.posts.create(
          title: Faker::Lorem.sentence(2),
          body: Faker::Lorem.sentence,
          photo: post_photo
        )
      end
    end
  end
end
