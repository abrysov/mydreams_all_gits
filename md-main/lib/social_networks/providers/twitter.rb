module SocialNetworks
  module Providers
    class Twitter < Base
      # {
      #   "provider"=>"twitter",
      #   "uid"     =>"3908031196",
      #   "info"    => {
      #     "nickname"=>"mydreams_club",
      #     "name"    =>"MyDreams club",
      #     "location"=>"Москва, Россия",
      #     "image"   =>"http://pbs.twimg.com/profile_images/681807367156199424/56W0-Tcp_normal.jpg",
      #     "description"=>"Проект, который меняет Мир.",
      #     "urls"    =>{"Website"=>"https://t.co/daTZBGYBbY", "Twitter"=>"https://twitter.com/mydreams_club"}
      #   },
      #   "credentials"=> {
      #     "token"=>"3908031196-K8RgeEdEgUuQCIkY2oClNmhxDi0IIWxJlDkCY1X",
      #     "secret"=>"IoYdi8PWvxn9opGly4BPeFcwGZlNT5x2hIh9KEuLcNy0K"
      #   },
      #   "extra"=> {
      #     "raw_info"=> {
      #        "id"=>3908031196,
      #        "id_str"=>"3908031196",
      #        "name"=>"MyDreams club",
      #        "screen_name"=>"mydreams_club",
      #        "location"=>"Москва, Россия",
      #        "description"=>"Проект, который меняет Мир.",
      #        "url"=>"https://t.co/daTZBGYBbY",
      #        "utc_offset"=>-25200,
      #        "verified"=>false,
      #        "lang"=>"ru",
      #        "has_extended_profile"=>true,
      #        "notifications"=>false
      #     }
      #   }
      # }

      def first_name
        @provider.meta[:info][:first_name] || name[0]
      end

      def last_name
        @provider.meta[:info][:last_name] || name[1]
      end

      def photo
        super.sub('_normal', '')
      end

      private

      def name
        @provider.meta[:info][:name].split(' ',2)
      end
    end
  end
end
