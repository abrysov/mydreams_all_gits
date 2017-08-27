module SocialNetworks
  module Providers
    class Vkontakte < Base
      # {
      #   "provider"=>"vkontakte",
      #   "uid"=>"1058906",
      #   "info"=> {
      #     "name"=>"Андрей Куманяев",
      #     "nickname"=>"Vladimirovich",
      #     "email"=>"me@zzet.org",
      #     "first_name"=>"Андрей",
      #     "last_name"=>"Куманяев",
      #     "image"=>"http://cs613416.vk.me/v613416906/b194/ADzNE_oa2WI.jpg",
      #     "location"=>"Россия, Москва",
      #     "urls"=>{
      #       "Vkontakte"=>"http://vk.com/zzet_org"
      #     }
      #   },
      #   "credentials"=> {
      #     "token"=> "secret_token",
      #     "expires_at"=>1456166773,
      #     "expires"=>true
      #   },
      #   "extra"=> {
      #     "raw_info"=> {
      #       "id"=>1058906,
      #       "first_name"=>"Андрей",
      #       "last_name"=>"Куманяев",
      #       "sex"=>2,
      #       "nickname"=>"Vladimirovich",
      #       "screen_name"=>"zzet_org",
      #       "bdate"=>"2.5.1989",
      #       "city"=>1,
      #       "country"=>1,
      #       "photo_50"=>"http://cs613416.vk.me/v613416906/b194/ADzNE_oa2WI.jpg",
      #       "photo_100"=>"http://cs613416.vk.me/v613416906/b193/ACsLT2NgQLA.jpg",
      #       "photo_200_orig"=>"http://cs613416.vk.me/v613416906/b190/EjQgMqxaM2A.jpg",
      #       "online"=>0
      #     }
      #   }
      # }

      def photo
        @provider.meta[:extra][:raw_info][:photo_200_orig]
      end
    end
  end
end
