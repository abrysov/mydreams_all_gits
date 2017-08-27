namespace :seed do
  task countries: :environment do
    if ENV['DELETE_OLD']
      DreamCity.destroy_all
      DreamRegion.destroy_all
      DreamDistrict.destroy_all
      DreamCountry.destroy_all
    end

    Seed::Countries.call
  end

  task cities: :environment do
    if ENV['DELETE_OLD']
      DreamCity.destroy_all

      moscow_city = DreamCity.create(
        osm_id: '1686293227', dream_country: DreamCountry.find_by(number: '643')
      )
      moscow_city.update_attributes(name: 'Москва', locale: 'ru')
      moscow_city.update_attributes(name: 'Moscow', locale: 'en')
    end

    DreamCountry.find_each { |country| Seed::Cities.call(country, 10) }
  end

  task dreamers: :environment do
    if ENV['DELETE_OLD']
      Account.destroy_all
      Avatar.destroy_all
      Dreamer.destroy_all

      admin = RegisterDreamer.call(
        password: 'password', role: :admin,
        first_name: 'Администратор', gender: 'male', confirmed_at: Time.now
      )
      admin.update_columns(email: 'moderator@project-email.com')
    end

    DreamCountry.find_each { |country| Seed::Dreamers.call(country, 2) }
  end

  task dreams: :environment do
    Dream.destroy_all if ENV['DELETE_OLD']

    Dreamer.find_each { |dreamer| Seed::Dreams.call(dreamer, 2) }
  end

  task photos: :environment do
    Photo.destroy_all if ENV['DELETE_OLD']

    Dreamer.find_each do |dreamer|
      number_creates = rand 1..3
      Seed::Photos.call(dreamer, number_creates)
    end
  end

  task posts: :environment do
    Post.destroy_all if ENV['DELETE_OLD']

    Dreamer.find_each do |dreamer|
      number_creates = rand 0..3
      with_photo = [true, false].sample
      Seed::Posts.call(dreamer, with_photo, number_creates)
    end
  end

  task comments: :environment do
    Comment.destroy_all if ENV['DELETE_OLD']

    Dreamer.find_each do |dreamer|
      number_creates = rand 0..10
      Seed::Comments.call(dreamer, number_creates)
    end
  end

  task likes: :environment do
    Like.destroy_all if ENV['DELETE_OLD']

    Dreamer.find_each do |dreamer|
      number_creates = rand 0..10
      Seed::Likes.call(dreamer, number_creates)
    end
  end

  task certificates: :environment do
    if ENV['DELETE_OLD']
      CertificateType.destroy_all
      Certificate.destroy_all

      CertificateType.create(
        [
          { id: 1, name: 'bronze', value: 1 },
          { id: 2, name: 'silver', value: 5 },
          { id: 3, name: 'gold', value: 10 },
          { id: 4, name: 'platinum', value: 50 },
          { id: 5, name: 'vip', value: 100 },
          { id: 6, name: 'presidential', value: 250 },
          { id: 7, name: 'imperial', value: 500 }
        ]
      )
    end

    Dreamer.find_each do |dreamer|
      number_creates = rand 0..10
      Seed::Certificates.call(dreamer, number_creates)
    end
  end

  task top_dreams: :environment do
    TopDream.destroy_all if ENV['DELETE_OLD']

    number_creates = rand 10..20

    Seed::TopDreams.call(number_creates)
  end

  task friends: :environment do
    Friendship.destroy_all if ENV['DELETE_OLD']

    Dreamer.find_each do |dreamer|
      number_creates = rand 0..5
      Seed::Friends.call(dreamer, number_creates)
    end
  end

  task subscriptions: :environment do
    Subscription.destroy_all if ENV['DELETE_OLD']

    Dreamer.find_each do |dreamer|
      number_creates = rand 0..5
      Seed::Subscriptions.call(dreamer, number_creates)
    end
  end

  task all: :environment do
    Rake::Task['seed:countries'].invoke
    Rake::Task['seed:cities'].invoke
    Rake::Task['seed:dreamers'].invoke
    Rake::Task['seed:dreams'].invoke
    Rake::Task['seed:photos'].invoke
    Rake::Task['seed:posts'].invoke
    Rake::Task['seed:top_dreams'].invoke
    Rake::Task['seed:comments'].invoke
    Rake::Task['seed:likes'].invoke
    Rake::Task['seed:certificates'].invoke
    Rake::Task['seed:friends'].invoke
    Rake::Task['seed:subscriptions'].invoke
  end
end
