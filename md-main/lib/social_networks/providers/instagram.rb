module SocialNetworks
  module Providers
    class Instagram < Base
      # {
      #   "provider"=>"instagram",
      #   "uid"=>"766420465",
      #   "info"=> {
      #     "nickname"=>"vencarbon",
      #     "name"=>"Jana Petrova",
      #     "image"=> "https://scontent.cdninstagram.com/t51.2885-19/10890973_623845464388720_372634440_a.jpg",
      #     "bio"=>"",
      #     "website"=>""
      #   },
      #   "credentials"=> {
      #     "token"=>"secret_token",
      #     "expires"=>false
      #   },
      #   "extra"=>{}
      # }
      def first_name
        @provider.meta[:info][:name].split.first
      end

      def last_name
        @provider.meta[:info][:name].split.last
      end
    end
  end
end
