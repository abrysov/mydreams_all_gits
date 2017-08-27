class Api::Web::FeedsController < Api::Web::ApplicationController
  def show
    posts = Posts::Feed.fetch(current_dreamer).
            includes(:photos, :dreamer).
            page(page).
            per(per_page)

    render json: posts,
           root: :feeds,
           include: '**',
           meta: { status: 'success', code: 200 }.merge(pagination_meta_for(posts)),
           status: :ok
  end
end
