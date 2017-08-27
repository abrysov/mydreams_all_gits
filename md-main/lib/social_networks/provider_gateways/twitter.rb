module SocialNetworks
  module ProviderGateways
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
      def auth_hash
        {
          provider: 'twitter',
          uid:      user.id,
          info: {
            email:       nil,
            nickname:    user.screen_name,
            name:        user.name,
            location:    user.location,
            image:       user.profile_image_uri.to_s,
            description: user.description,
            urls: { "Twitter" => user.url.to_s }
          },
          credentials: {
            token:  @token,
            secret: @secret
          },
          extra: {
            raw_info: {
               id:            user.id,
               id_str:        user.id.to_s,
               name:          user.name,
               screen_name:   user.screen_name,
               location:      user.location,
               description:   user.description,
               url:           "https://t.co/daTZBGYBbY",
               utc_offset:    user.utc_offset,
               verified:      user.verified?,
               lang:          user.lang,
               notifications: user.notifications?
            }
          }
        }
      end

      private

      def user
        @user ||= ::Twitter::REST::Client.new do |config|
          config.consumer_key        = Rails.application.secrets.twitter_key
          config.consumer_secret     = Rails.application.secrets.twitter_secret
          config.access_token        = @token
          config.access_token_secret = @secret
        end.user
      end

    end
  end
end
