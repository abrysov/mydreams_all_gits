module SocialNetworks
  module ProviderGateways
    class Facebook < Base
      # {
      #   id: "581134262042256",
      #   email: "ivan.molot@gmail.com",
      #   first_name: "Ivan",
      #   gender: "male",
      #   last_name: "Petrov",
      #   link: "https://www.facebook.com/app_scoped_user_id/581134262042256/",
      #   locale: "ru_RU",
      #   name: "Ivan Petrov",
      #   timezone: 4,
      #   updated_time: "2012-09-29T13:20:09+0000",
      #   verified: false
      # }
      def auth_hash
        res = uri_json_response "https://graph.facebook.com/me?access_token=#{@token}"

        {
          provider: 'facebook',
          uid: res['id'],
          info: {
            email: res['email'],
            name: res['name'],
            first_name: res['first_name'],
            last_name: res['last_name'],
            urls: {
              'Facebook' => res['link']
            },
            verified: res['verified'],
            image: "http://graph.facebook.com/#{res['id']}/picture"
          },
          extra: {
            raw_info: res
          }
        }
      end
    end
  end
end
