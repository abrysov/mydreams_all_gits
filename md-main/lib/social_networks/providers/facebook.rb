module SocialNetworks
  module Providers
    class Facebook < Base
      # {
      #   "provider"=>"facebook",
      #   "uid"=>"1231039683589282",
      #   "info"=> {
      #     "email"=>"me@zzet.org",
      #     "name"=>"Andrew Kumanyaev",
      #     "first_name"=>"Andrew",
      #     "last_name"=>"Kumanyaev",
      #     "image"=>"http://graph.facebook.com/1231039683589282/picture",
      #     "urls"=> {
      #       "Facebook"=> "https://www.facebook.com/app_scoped_user_id/1231039683589282/"
      #     },
      #     "verified"=>true
      #   },
      #   "credentials"=> {
      #     "token"=> "secret_token",
      #     "expires_at"=>1461264310,
      #     "expires"=>true
      #   },
      #   "extra"=> {
      #     "raw_info"=> {
      #       "id"=>"1231039683589282",
      #       "email"=>"me@zzet.org",
      #       "first_name"=>"Andrew",
      #       "gender"=>"male",
      #       "last_name"=>"Kumanyaev",
      #       "link"=>"https://www.facebook.com/app_scoped_user_id/1231039683589282/",
      #       "locale"=>"ru_RU",
      #       "name"=>"Andrew Kumanyaev",
      #       "timezone"=>3,
      #       "updated_time"=>"2015-06-06T05:17:40+0000",
      #       "verified"=>true
      #     }
      #   }
      # }
      def first_name
        @provider.meta[:info][:first_name] || name.split(' ').first
      end

      def last_name
        @provider.meta[:info][:last_name] || name.split(' ').last
      end

      def name
        @provider.meta[:info][:name]
      end

      def email
        @provider.meta[:info][:email]
      end

      def photo
        super.sub('http://', 'https://') + '?width=9999'
      end

      def gender
        @provider.meta[:extra][:raw_info][:gender]
      end
    end
  end
end
