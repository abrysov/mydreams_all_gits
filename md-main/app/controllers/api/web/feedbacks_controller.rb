class Api::Web::FeedbacksController < Api::Web::ApplicationController
  def index
    feedbacks = current_dreamer.feedbacks.order(id: :desc).page(page).per(per_page)

    render json: feedbacks,
           each_serializer: FeedbackSerializer,
           meta: { status: 'success', code: 200 }.merge(pagination_meta_for(feedbacks)),
           status: :ok
  end
end
