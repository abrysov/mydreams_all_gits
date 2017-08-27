class Api::V1::Feed::UpdatesController < Api::V1::ApplicationController
  def index
    updates = current_dreamer.notifications.
              order(created_at: :desc).
              page(page).
              per(per_page)

    render json: updates,
           root: :updates,
           include: '**',
           meta: { status: 'success', code: 200 }.merge(pagination_meta_for(updates)),
           status: :ok
  end
end
