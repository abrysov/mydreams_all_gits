module Seed
  class Countries
    def self.call
      I18n.available_locales.each do |locale|
        locale = locale.to_s
        code = locale == 'en' ? 'us' : locale
        country = ISO3166::Country.new(code.upcase)

        next unless country

        dream_country = DreamCountry.create(code: country.alpha2, number: country.number)
        country_name = country.translations[locale] || country.translations['en']
        dream_country.update_attributes(name: country_name, locale: locale)
        dream_country.update_attributes(name: country.translations['ru'], locale: 'ru')
        dream_country.update_attributes(name: country.translations['en'], locale: 'en')
      end
    end
  end
end
