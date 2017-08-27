module Seed
  class Dreamers
    def self.call(country, number_creates)
      code = country.code.downcase
      locale = code == 'us' ? 'en' : code

      Faker::Config.locale = locale
      I18n.locale = locale

      number_creates.times do
        sex = [true, false].sample
        avatar = Seed::RandomImage.call if [true, false].sample
        new_dreamer = RegisterDreamer.call(
          password: 'password', first_name: first_name, last_name: last_name,
          gender: sex ? 'male' : 'female', birthday: rand(18..60).years.ago,
          phone: Faker::Base.numerify('+7 (###) ### ####'),
          dream_country: country,
          dream_city: country.dream_cities.order('RANDOM()').first,
          confirmed_at: Time.zone.now,
          is_vip: [true, false].sample,
          celebrity: [true, false].sample,
          project_dreamer: [true, false].sample, avatar: avatar
        )
        new_dreamer.update_columns(email: Faker::Internet.email)
      end
    end

    def self.first_name
      Faker::Name.male_first_name
    rescue NoMethodError
      Faker::Name.first_name
    end

    def self.last_name
      Faker::Name.male_last_name
    rescue NoMethodError
      Faker::Name.last_name
    end
  end
end
