module Seed
  class Cities
    def self.call(country, number_creates)
      code = country.code.downcase
      locale = code == 'us' ? 'en' : code

      Faker::Config.locale = locale
      I18n.locale = locale

      number_creates.times do
        city_name = Faker::Address.city

        if country.dream_cities.exists?(name: city_name)
          city_name = Faker::Address.city
        end

        new_city = country.dream_cities.create
        new_city.update_attributes(name: city_name, locale: locale)
        new_city.update_attributes(name: city_name, locale: 'ru')
        new_city.update_attributes(name: city_name, locale: 'en')
      end
    end
  end
end
