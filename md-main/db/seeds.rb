
certificates = [
  { id: 1, name: 'bronze', value: 1 },
  { id: 2, name: 'silver', value: 5 },
  { id: 3, name: 'gold', value: 10 },
  { id: 4, name: 'platinum', value: 50 },
  { id: 5, name: 'vip', value: 100 },
  { id: 6, name: 'presidential', value: 250 },
  { id: 7, name: 'imperial', value: 500 }
]

CertificateType.delete_all
CertificateType.create!(certificates)

DreamCity.destroy_all
DreamRegion.destroy_all
DreamDistrict.destroy_all
DreamCountry.destroy_all

dream_country_ru = DreamCountry.create!(code: 'RU', number: '643', osm_id: '60189')
dream_country_ru.update_attributes(name: 'Российская Федерация', locale: 'ru')
dream_country_ru.update_attributes(name: 'Russian Federation', locale: 'en')

DreamCity.destroy_all
dream_city_ru_1 = DreamCity.create!(osm_id: '1686293227', dream_country: dream_country_ru)
dream_city_ru_1.update_attributes(name: 'Москва', locale: 'ru')
dream_city_ru_1.update_attributes(name: 'Moscow', locale: 'en')

dream_city_ru_1 = DreamCity.create!(osm_id: '1686293227', dream_country: dream_country_ru)
dream_city_ru_1.update_attributes(name: 'Москва', locale: 'ru')
dream_city_ru_1.update_attributes(name: 'Moscow', locale: 'en')

dream_city_ru_2 = DreamCity.create!(osm_id: '711715624', dream_country: dream_country_ru)
dream_city_ru_2.update_attributes(name: 'Ульяновск', locale: 'ru')
dream_city_ru_2.update_attributes(name: 'Ulyanovsk', locale: 'en')

dream_city_ru_3 = DreamCity.create!(osm_id: '27505266', dream_country: dream_country_ru)
dream_city_ru_3.update_attributes(name: 'Ярославль', locale: 'ru')
dream_city_ru_3.update_attributes(name: 'Yaroslavl', locale: 'en')

moscow = DreamCity.search_by_name('Москва').first
russia = DreamCountry.search_by_name('Российская Федерация').first
if Rails.env.development?
  Dreamer.destroy_all
  RegisterDreamer.call(
    password: 'password', first_name: 'Генадий',
    last_name: 'Букин', birthday: 20.years.ago, gender: 'male', project_dreamer: true,
    phone: '+7 (953) 644-50-44', dream_country: russia, dream_city: moscow, confirmed_at: Time.now
  )
  RegisterDreamer.call(
    password: 'password', first_name: 'Анна',
    last_name: 'Семенович', birthday: 35.years.ago, gender: 'female',
    phone: '+7 (945) 157-99-92', dream_country: russia, dream_city: moscow, confirmed_at: Time.now
  )
  RegisterDreamer.call(
    password: 'password', first_name: 'Олег',
    last_name: 'Газманов', birthday: 10.years.ago, gender: 'male',
    phone: '+7 (925) 672-26-60', dream_country: russia, dream_city: moscow, confirmed_at: Time.now
  )

  RegisterDreamer.call(
    email: 'moderator@project-email.com', password: 'password',
    first_name: 'Администратор', gender: 'male', confirmed_at: Time.now
  )

  upload_file = Rack::Test::UploadedFile.new(File.open('spec/fixtures/avatar.jpg'))
  dreamer = Dreamer.first

  Dream.delete_all
  Dream.create!(
    [
      { dreamer_id: 1, title: 'Дача в Одинцово', photo: upload_file,
        dreamer: dreamer, description: 'test' },
      { dreamer_id: 2, title: 'Золотой iPhone 6 Plus', photo: upload_file,
        dreamer: dreamer, description: 'test' },
      { dreamer_id: 3, title: 'Золотой iPhone 7 Plus', photo: upload_file,
        dreamer: dreamer, description: 'test' },
      { dreamer_id: 4, title: 'Золотой iPhone 8 Plus', photo: upload_file,
        dreamer: dreamer, description: 'test' },
      { dreamer_id: 5, title: '2015 Mercedes-Benz SLS AMG', photo: upload_file,
        dreamer: dreamer, description: 'test' }
    ]
  )

end

Setting.create!(
  [
    { key: 'certificate_price', value: 100 },
    { key: 'vip_status_price', value: 100 }
  ]
)

Product.destroy_all

certificates.map do |cert|
  amount = Setting.certificate_price * cert[:value]
  product = Product.create!(name: cert[:name], cost: amount, product_type: :cert)
  ProductProperty.create!(product: product, key: 'certificate_name', value: cert[:name])
  ProductProperty.create!(product: product, key: 'certificate_launches', value: cert[:value])
end

product = Product.create!(name: 'Vip status', cost: 2000, product_type: :vip)
ProductProperty.create!(product: product, key: 'vip_duration', value: 30)
