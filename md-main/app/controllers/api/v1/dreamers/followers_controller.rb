class Api::V1::Dreamers::FollowersController < Api::V1::Dreamers::ApplicationController
  def index
    followers = Followers::FollowersFinder.new(dreamer.followers).
                filter(params).
                page(page).per(per_page)

    render json: followers,
           root: :followers,
           meta: { status: 'success', code: 200 }.merge(pagination_meta_for(followers)),
           status: :ok
  end
end
