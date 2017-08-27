module Seed
  class Comments
    def self.call(dreamer, number_creates)
      number_creates.times do
        dreamer.comments.create(
          body: Faker::Lorem.sentence,
          commentable: Seed::RandomEntity.call
        )
      end
    end
  end
end
