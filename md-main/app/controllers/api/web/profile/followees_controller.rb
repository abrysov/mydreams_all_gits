class Api::Web::Profile::FolloweesController < Api::Web::Profile::ApplicationController
  def index
    followees = Followees::FolloweesFinder.new(current_dreamer.not_friends_followees).
                filter(params).
                page(page).per(per_page)

    render json: followees,
           root: :dreamers,
           meta: { status: 'success', code: 200 }.merge(pagination_meta_for(followees)),
           status: :ok
  end
end
