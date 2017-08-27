class Api::V1::Dreamers::FriendsController < Api::V1::Dreamers::ApplicationController
  def index
    friends = Friends::FriendsFinder.new(dreamer.friends).
              filter(params).
              page(page).per(per_page)

    render json: friends,
           root: :friends,
           meta: { status: 'success', code: 200 }.merge(pagination_meta_for(friends)),
           status: :ok
  end
end
