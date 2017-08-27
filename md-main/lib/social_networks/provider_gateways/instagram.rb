module SocialNetworks
  module ProviderGateways
    class Instagram < Base

      # {
      #   "meta":{"code":200},
      #   "data":{
      #     "username":"koshobaka",
      #     "bio":"",
      #     "website":"",
      #     "profile_picture":"https:\/\/scontent.cdninstagram.com\/t51.2885-19\/11849923_509483802540034_473258010_a.jpg",
      #     "full_name":"Ev",
      #     "counts":{"media":73,"followed_by":46,"follows":46},
      #     "id":"253116782"}
      # }
      def auth_hash
        res = uri_json_response "https://api.instagram.com/v1/users/self/?access_token=#{@token}"
        res = res["data"]

        {
          provider: 'instagram',
          uid: res['id'],
          info: {
            email: nil,
            name: res['full_name'],
            first_name: nil,
            last_name: nil,
            urls: {
              'Twitter' => nil
            },
            verified: nil,
            image: res['profile_picture']
          },
          extra: {
            raw_info: res
          }
        }
      end
    end
  end
end
