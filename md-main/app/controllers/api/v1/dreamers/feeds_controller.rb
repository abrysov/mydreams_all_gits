class Api::V1::Dreamers::FeedsController < Api::V1::Dreamers::ApplicationController
  def index
    posts = Posts::DreamerFeed.fetch(current_dreamer, dreamer).page(page).per(per_page)

    render json: posts,
           root: :feeds,
           include: '**',
           meta: { status: 'success', code: 200 }.merge(pagination_meta_for(posts)),
           status: :ok
  end
end
