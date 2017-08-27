class Api::Web::Feed::CommentsController < Api::Web::ApplicationController
  def index
    posts = Posts::Commented.fetch(current_dreamer, params).
            page(page).per(per_page)

    render json: posts,
           root: :comments,
           include: '**',
           meta: { status: 'success', code: 200 }.merge(pagination_meta_for(posts)),
           status: :ok
  end
end
