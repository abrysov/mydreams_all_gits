class ProcessDreamCity
  def self.search_dream_cities(name: nil, country_id: nil, limit: 50)
    return unless name

    name = capitalize_words(name)

    if country_id
      DreamCity.search_by_name(name).where(dream_country_id: country_id).limit(limit)
    else
      DreamCity.search_by_name(name).limit(limit)
    end
  end

  def self.create_dream_city(city_name: nil, country_id: nil, region_name: nil, district_name: nil)
    city_name = capitalize_words(city_name)

    return unless city_name && DreamCountry.find_by(id: country_id)

    dream_region = DreamRegion.includes(:translations).find_by(name: region_name)
    dream_district = DreamDistrict.includes(:translations).find_by(name: district_name)
    dream_city = DreamCity.includes(:translations).
      find_or_create_by(dream_country_id: country_id, name: city_name) do |city|
      city.name = city_name
      city.dream_region = dream_region
      city.dream_district = dream_district
    end

    dream_city
  end

  private

  def self.capitalize_words(words)
    return unless words

    words.split.map { |word| word.mb_chars.capitalize }.join(' ')
  end
end
