class Api::Web::Dreamers::FeedsController < Api::Web::Dreamers::ApplicationController
  def index
    posts = Posts::DreamerFeed.fetch(current_dreamer, dreamer).page(page).per(per_page)

    render json: posts,
           root: :feeds,
           include: '**',
           each_serializer: PostSerializer,
           meta: { status: 'success', code: 200 }.merge(pagination_meta_for(posts)),
           status: :ok
  end
end
