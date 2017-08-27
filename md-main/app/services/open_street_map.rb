MultipleRequestsError = Class.new(StandardError)

class OpenStreetMap
  LOCALES = [:ru, :au, :at, :az, :ai, :am, :by, :be, :bg, :br, :gb, :hu, :vn, :fr, :de, :ua, :gr,
             :ge, :do, :il, :in, :id, :ie, :es, :it, :kz, :ca, :cy, :kg, :cn, :kp, :lv, :lt, :lu,
             :np, :mx, :md, :nl, :nz, :no, :pl, :pt, :ro, :us, :sv, :sg, :sy, :sk, :si, :tj, :th,
             :tm, :tm, :tr, :uz, :ua, :fi, :fr, :cz, :ch, :se, :ee, :en, :kr, :jp].freeze

  @alternate_endpoint = false

  def self.locales
    LOCALES
  end

  def self.endpoint_toggle
    @alternate_endpoint = !@alternate_endpoint
  end

  def self.get_attributes(data, loc)
    return if data[:name].nil?

    {
      name: data[:"name:#{loc}"],
      locale: loc
    }
  end

  def self.call_overpass_api(query)
    return unless query

    template = "[out:json][timeout:900];
    #{query}out;".squish.gsub('] [', '][').squish.gsub('; ', ';')

    endpoint = if @alternate_endpoint
                 'http://overpass.osm.rambler.ru/cgi/interpreter?data='
               else
                 'http://overpass-api.de/api/interpreter?data='
               end

    Rails.logger.info 'Send request to ' + endpoint

    url = URI.parse("#{endpoint}#{template}")
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port, read_timeout: 3000) do |http|
      http.request(req)
    end

    fail MultipleRequestsError if res.code == '429'

    JSON.parse(res.body, symbolize_names: true)[:elements]
  end

  def self.find_by_nominatim(query, country_code: nil)
    addition_params = ''
    addition_params += "&countrycodes=#{country_code}" if country_code

    query = capitalize_words(query)
    endpoint = "http://nominatim.openstreetmap.org/search?q=#{URI.escape(query)}&" \
      "addressdetails=1&format=json&accept-language=#{I18n.locale}#{addition_params}"

    sleep(2)

    api_call_tries = 2
    begin
      response = call_nominatim(endpoint)
      result = JSON.parse(response, symbolize_names: true)
    rescue JSON::ParserError
      Rails.logger.info 'invoke Rescue, send request to nominatom with delay'
      sleep(5.minutes)
      retry unless api_call_tries.zero?
    ensure
      if api_call_tries.zero?
        result = nil
      end
    end

    result
  end

  def self.call_nominatim(endpoint)
    url = URI.parse(endpoint)
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port, read_timeout: 1000) do |http|
      http.request(req)
    end

    res.body
  end

  def self.find_country_by_name(dreamer_country)
    return unless dreamer_country

    country_name = dreamer_country.name_ru
    dream_country = DreamCountry.search_by_name(country_name).first
    dream_region = nil

    if dream_country.nil?
      nominatim = OpenStreetMap.find_by_nominatim(country_name).first

      return unless nominatim

      if nominatim[:address][:state] && nominatim[:address][:state].mb_chars.downcase == country_name.mb_chars.downcase
        dream_country = DreamCountry.find_by(code: nominatim[:address][:country_code].upcase)

        dream_region = DreamRegion.search_by_name(nominatim[:address][:state]).first
      else
        dream_country = DreamCountry.find_by(code: nominatim[:address][:country_code].upcase)
      end
    end

    [dream_country, dream_region].flatten
  end

  def self.find_or_create_city(dreamer_city, dream_country, dream_region)
    return unless dreamer_city

    city_name = dreamer_city.name_ru
    dream_city = DreamCity.search_by_name(city_name).first

    if dream_city.nil?
      nominatim = OpenStreetMap.find_by_nominatim(city_name,
        country_code: dream_country.code.downcase).first

      if nominatim

        if nominatim[:address][:state] && dream_region.nil?
          dream_region = DreamRegion.search_by_name(nominatim[:address][:state]).first
        end

        if nominatim[:osm_type] == 'relation'
          node = node_by_relation(nominatim[:osm_id]).first
          dream_city = save_city(node, dream_country, dream_region, nil)
        elsif nominatim[:osm_type] == 'node'
          node = node_by_id(nominatim[:osm_id]).first
          dream_city = save_city(node, dream_country, dream_region, nil)
        end
      end
    end

    if dream_city.nil?
      dream_city = DreamCity.create(dream_country: dream_country, dream_region: dream_region)

      dream_city.attributes = { name: dreamer_city.name_ru, locale: :ru }
      dream_city.attributes = { name: dreamer_city.name_en, locale: :en }
      dream_city.save
    end

    if dream_city.name.nil?
      dream_city.attributes = { name: dreamer_city.name_ru, locale: :ru }
      dream_city.attributes = { name: dreamer_city.name_en, locale: :en }
      dream_city.save
    end
    Rails.logger.info 'dream city finded:' + dream_city.name if dream_city
    dream_city
  end

  def self.node_by_relation(relation_osm_id)
    query = "rel(#{relation_osm_id});
    node(r);
    out;"

    call_overpass_api(query)
  end

  def self.node_by_id(node_id)
    query = "node(#{node_id});
    out;"

    call_overpass_api(query)
  end

  def self.process_nodes(country, type)
    pattern = case type
              when 'city'
                '[place~"(city|town)"]'
              when 'village'
                '[place="village"]'
              end

    query = "
      area[\"ISO3166-1:numeric\"=\"#{country.number}\"];
      node#{pattern}(area)->.cities;
      foreach.cities(
        out;
        is_in;
        area._[admin_level~\"[46]\"];
        out ids;
      );
      .cities is_in;
      area._[admin_level~\"[46]\"];
    "
    api_call_tries = 2
    begin
      result = call_overpass_api(query)
    rescue MultipleRequestsError
      Rails.logger.info 'invoke Rescue, send request to an alternate endpoint'
      endpoint_toggle
      api_call_tries -= 1
      retry unless api_call_tries.zero?
    rescue JSON::ParserError
      Rails.logger.info 'invoke Rescue, send request to an alternate endpoint'
      endpoint_toggle
      api_call_tries -= 1
      retry unless api_call_tries.zero?
    ensure
      if api_call_tries.zero?
        result = nil
        sleep(5.minutes)
      end
    end

    return unless result

    result.each_with_index do |item, index|
      next unless item[:type] == 'node'
      next if item[:tags][:population] && item[:tags][:population].to_i < 5000

      positions = []
      1.upto(2) do |pos|
        pos_data = normalize_identificator(result[index + pos])
        break if pos_data.nil?
        positions << pos_data
      end

      dream_country = country
      dream_region = DreamRegion.includes(:translations).find_by(osm_id: positions)
      dream_district = DreamDistrict.includes(:translations).find_by(osm_id: positions)

      save_city(item, dream_country, dream_region, dream_district)
    end
  end

  def self.save_relation(data)
    return unless data

    relation = case data[:tags][:admin_level]
               when '2'
                 return unless data[:tags][:'ISO3166-1:numeric'] &&
                               data[:tags][:boundary] == 'administrative' &&
                               (data[:tags][:'ISO3166-1:alpha2'] || data[:tags][:'ISO3166-1'])
                 code = data[:tags][:'ISO3166-1:alpha2'] || data[:tags][:'ISO3166-1']
                 country = DreamCountry.find_or_create_by(osm_id: data[:id])
                 country.update_attributes(number: data[:tags][:'ISO3166-1:numeric'], code: code)
                 country
               when '4'
                 DreamRegion.find_or_create_by(osm_id: data[:id])
               when '6'
                 DreamDistrict.find_or_create_by(osm_id: data[:id])
               end

    translations = LOCALES.map { |loc| get_attributes(data[:tags], loc) }.compact
    translations.each { |translate| relation.attributes = translate }

    if relation.save
      Rails.logger.info "Admin level with id #{relation.id} saved"
    else
      Rails.logger.info 'Admin level not saved'
    end

    relation
  end

  def self.save_city(city, country, region, district)
    return unless city

    dream_city = DreamCity.find_or_create_by(osm_id: city[:id])
    dream_city.postcode = city[:tags][:'addr:postcode'] if city[:tags][:'addr:postcode']

    dream_city.dream_country = country if country
    dream_city.dream_region = region if region
    dream_city.dream_district = district if district

    if country && region && region.dream_country_id.nil?
      region.update_attributes(dream_country: country)
    end

    if country && district && district.dream_country_id.nil?
      district.update_attributes(dream_country: country)
    end

    if region && district && district.dream_region_id.nil?
      district.update_attributes(dream_region: region)
    end

    translations = LOCALES.map { |loc| get_attributes(city[:tags], loc) }.compact
    translations.each { |translate| dream_city.attributes = translate }

    if dream_city.save
      Rails.logger.info "City with id #{dream_city.id} saved"
    else
      Rails.logger.info 'City not saved'
    end

    dream_city
  end

  def self.normalize_identificator(area)
    return unless area && area[:type] == 'area'

    area[:id] - 360_000_000_0
  end
end
