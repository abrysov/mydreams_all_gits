namespace :tags do
  desc 'populate tags (x100)'
  task populate: :environment do
    paths = [
      %w[Электроника Apple iphone iphone5 iphone5\ 64gb],
      %w[Электроника Apple iphone iphone5 iphone5\ 128gb],
      %w[Электроника Apple iphone iphone6 iphone6\ 32gb],
      %w[Электроника Apple iphone iphone6 iphone6\ 64gb],
      %w[Электроника Apple iphone iphone6 iphone6\ 32gb],
      %w[Электроника Apple iphone iphone6 iphone6\ 128gb],
      %w[Электроника Apple iphone iphone6s iphone6s\ 64gb],
      %w[Электроника Apple iphone iphone6s iphone6s\ 128gb],
      %w[Электроника Apple iphone iphone7 iphone7\ 64gb],
      %w[Электроника Apple iphone iphone7 iphone7\ 128gb],
      %w[Электроника Apple ipad ipad\ mini],
      %w[Электроника Apple ipad ipad\ mini2],
      %w[Электроника Apple ipad ipad\ Pro],
      %w[Электроника Apple Imac Imac\ 32],
      %w[Электроника Apple Imac Imac\ 34],
      %w[Электроника Apple Imac Imac\ 36],
      %w[Электроника Apple mac\ mini mac\ mini\ low],
      %w[Электроника Apple mac\ mini mac\ mini\ top],
      %w[Электроника Apple ipod nano],
      %w[Электроника Apple ipod ipod\ 2g],
      %w[Электроника Apple ipod ipod\ 3g],
      %w[Электроника Apple ipod ipod\ 4g],
      %w[Электроника Apple ipod ipod\ 5g],
      %w[Электроника Samsung smartphone Galaxy\ S5],
      %w[Электроника Samsung smartphone Galaxy\ S6],
      %w[Электроника Samsung smartphone Galaxy\ S7],
      %w[Электроника Samsung phablet Galaxy\ S8],
      %w[Электроника Samsung TV TV4DSUPERTHIN],
      %w[Электроника Samsung TV TV5DSUPERTHIN],
      %w[Электроника Xaomi smartphone mi5],
      %w[Электроника Xaomi smartphone mi4],
      %w[Электроника Xaomi smartphone redmi/ note/ 3],
      %w[Электроника Xaomi smartphone redmi/ note/ 4],
      %w[Электроника Xaomi smartphone redmi/ note/ 4],
      %w[Электроника SONY Sony\ PlayStation],
      %w[Электроника SONY Sony\ PlayStation Joystick PS3],
      %w[Электроника SONY Sony\ PlayStation Joystick PS4],
      %w[Электроника SONY Sony\ PlayStation Joystick PS5],
      %w[Электроника Видеокамеры Gopro],
      %w[Электроника Видеокамеры Philips G4],
      %w[Электроника Видеокамеры Panasonic PanasonicHC-V160],
      %w[Электроника Фотоокамеры Panasonic Panasonic60],
      %w[Электроника Плееры Cowon cowon64],
      %w[Электроника Плееры Cowon cowon128],
      %w[Офисная\ техника HP Принтеры LaserJet1200],
      %w[Офисная\ техника HP Принтеры LaserJet2200],
      %w[Офисная\ техника HP Сканеры ScanJet1200],
      %w[Офисная\ техника HP Сканеры ScanJet2200],
      %w[Офисная\ техника HP Сканеры Xerox XS2000],
      %w[Офисная\ техника XEROX Принтеры XS2000],
      %w[Офисная\ техника XEROX Принтеры XS1000],
      %w[Офисная\ техника XEROX Сканеры XScan1000],
      %w[Офисная\ техника XEROX Сканеры XScan1000],
      %w[Бытовая\ техника, Кондиционеры\ Ballu Ballu\ BSE-07HN1],
      %w[Бытовая\ техника, Холодильники\ Indesit Indesit\ SB\ 167],
      %w[Мото Шины EFX-Motogrip],
      %w[Часы Наручные\ часы SWISS\ MILITARY],
      %w[Чай пакетированный Lipton],
      %w[Чай пакетированный Ahmad],
      %w[Чай пакетированный Майский],
      %w[Чай листовой Lipton],
      %w[Чай листовой Ahmad],
      %w[Чай листовой Майский]
    ]
    paths.each do |path|
      Tag.find_or_create_by_path(path)
    end
  end
end
