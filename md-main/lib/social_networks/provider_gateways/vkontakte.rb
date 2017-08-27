module SocialNetworks
  module ProviderGateways
    class Vkontakte < Base
      # {
      #   "response": [
      #     {
      #       "id": 327117754,
      #       "first_name": "My-Dreams",
      #       "last_name": "Club",
      #       "sex": 2,                       1 - female, 2 - male, 0 - не указан
      #       "domain": "id327117754",
      #       "bdate": "3.12.1984",
      #       "city": {
      #         "id": 1,
      #         "title": "Москва"
      #       },
      #       "country": {
      #         "id": 1,
      #         "title": "Россия"
      #       },
      #       "photo_50": "https://pp.vk.me/c627720/v627720754/2d0a6/bCGV-Lsugg8.jpg",
      #       "verified": 0                   0 not verified / 1 - verified
      #     }
      #   ]
      # }

      def auth_hash
        res = uri_json_response(url)['response'][0]

        {
          provider: 'vkontakte',
          uid: res['uid'],
          info: {
            first_name: res['first_name'],
            last_name: res['last_name'],
            gender: res['sex'] == 2,
            urls: {
              'Vkontakte' => 'http://vk.com/' + res['domain']
            },
            verified: res['verified'] == 1 ? true : false,
            image: res['photo_50']
          },
          extra: {
            raw_info: res
          }
        }

      end

      private

      def url
        vk_api = 'https://api.vk.com/method/users.get?'
        fields = 'fields= photo_50, city, verified, sex, bdate, domain, country'
        token  = "access_token=#{@token}"
        [ vk_api, fields, token].join('&')
      end
    end
  end
end
