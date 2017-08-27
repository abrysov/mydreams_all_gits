namespace :overpass do
  task countries: :environment do
    query = 'relation["admin_level"~"[246]"];'

    result = OpenStreetMap.call_overpass_api(query)

    result.each do |level|
      next unless [2, 4, 6].include? level[:tags][:admin_level].to_i
      OpenStreetMap.save_relation(level)
    end
  end

  task cities: :environment do
    DreamCountry.all.each do |country|
      OpenStreetMap.process_nodes(country, 'city')
    end
  end

  task villages: :environment do
    codes = OpenStreetMap.locales.map { |loc| loc.to_s.upcase }

    DreamCountry.where(code: codes).each do |country|
      OpenStreetMap.process_nodes(country, 'village')
    end

    DreamCountry.where.not(code: codes).each do |country|
      OpenStreetMap.process_nodes(country, 'village')
    end
  end

  task return_locale_codes: :environment do
    ["Россия", "Австралия", "Австрия", "Азербайджан", "Англия", "Армения", "Беларусь",
     "Бельгия", "Болгария", "Бразилия", "Великобритания", "Венгрия", "Вьетнам", "Гваделупа",
     "Германия", "Голландия", "Греция", "Грузия", "Доминиканская республика", "Израиль",
     "Индия", "Индонезия", "Ирландия", "Испания", "Италия", "Казахстан", "Канада", "Кипр",
     "Кыргызстан", "Китай", "Северная Корея", "Латвия", "Литва", "Люксембург", "Мальта",
     "Мексика", "Молдова", "Нидерланды", "Новая Зеландия", "Норвегия", "Польша",
     "Португалия", "Румыния", "США", "Сальвадор", "Сингапур", "Сирия", "Словакия",
     "Словения", "Таджикистан", "Тайланд", "Туркменистан", "Туркмения", "Турция",
     "Узбекистан", "Украина", "Финляндия", "Франция", "Чехия", "Швейцария", "Швеция",
     "Эстония", "Южная Корея", "Япония"].map do |land|
      endpoint = "http://nominatim.openstreetmap.org/search?q=#{URI.escape(land)}&addressdetails=1&format=json"

      url = URI.parse(endpoint)
      req = Net::HTTP::Get.new(url.to_s)
      res = Net::HTTP.start(url.host, url.port, read_timeout: 3000) do |http|
        http.request(req)
      end

      result = JSON.parse(res.body, symbolize_names: true)
      result.first[:address][:country_code].to_sym
    end
  end

  task migrate_users: :environment do
    I18n.locale = :ru
    Dreamer.where(dream_city_id: nil).find_each do |user|
      if user.dreamer_country
        country_id = user.dreamer_country_id
        dream_country_id, dream_region_id = Rails.cache.fetch("#{country_id}/country", expires_in: 12.hours) do
          c, r = OpenStreetMap.find_country_by_name(user.dreamer_country)
          [c.id, r.id]
        end
        dream_country = DreamCountry.find(dream_country_id)
        dream_region = DreamRegion.find(dream_region_id)
      end

      if user.dreamer_city
        city_id = user.dreamer_city_id
        dream_city_id = Rails.cache.fetch("#{city_id}/city", expires_in: 12.hours) do
          c = OpenStreetMap.find_or_create_city(user.dreamer_city, dream_country, dream_region)
          c.id
        end

        dream_city = DreamCity.find(dream_city_id)
      end

      user.dream_country = dream_country if dream_country
      #user.dream_region = dream_region if dream_region
      user.dream_city = dream_city if dream_city
      user.save
    end
  end
end
