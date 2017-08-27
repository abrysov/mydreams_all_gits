class Api::Web::Dreamers::FriendsController < Api::Web::Dreamers::ApplicationController
  def index
    friends = Friends::FriendsFinder.new(dreamer.friends).
              filter(params).
              page(page).per(per_page)

    render json: friends,
           root: :dreamers,
           meta: { status: 'success', code: 200 }.merge(pagination_meta_for(friends)),
           status: :ok
  end
end
