namespace :i18n do
  desc "TODO"
  task countries: :environment do
    LOCALES = [:en, :ru].freeze

    all_countries = ISO3166::Country.all

    all_countries.each do |country|
      attributes = LOCALES.map do |loc|
        get_country_attributes(country, loc)
      end

      save_country(country.number, attributes)
    end
  end

  def save_country(number, attributes)
    dream_country = DreamCountry.find_or_create_by(number: number)
    attributes.each do |attr|
      dream_country.attributes = attr
    end
    dream_country.save
  end

  def get_country_attributes(country, locale)
    I18n.locale = locale
    title = I18n.t(country.alpha2, scope: :countries)
    { title: title, code: country.alpha2, number: country.number, locale: locale }
  end
end
