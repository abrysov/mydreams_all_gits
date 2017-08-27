class Api::Web::Feed::RecommendationsController < Api::Web::ApplicationController
  def index
    posts = Posts::Recommended.fetch(current_dreamer, params).
            page(page).per(per_page)

    render json: posts,
           root: :recommendations,
           include: '**',
           meta: { status: 'success', code: 200 }.merge(pagination_meta_for(posts)),
           status: :ok
  end
end
