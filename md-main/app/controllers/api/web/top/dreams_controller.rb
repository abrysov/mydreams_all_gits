class Api::Web::Top::DreamsController < Api::Web::ApplicationController
  def index
    dreams = TopDream.most_liked.page(page).per(per_page)

    render json: dreams,
           each_serializer: TopDreamSerializer,
           meta: { status: 'success', code: 200 }.merge(pagination_meta_for(dreams)),
           status: :ok
  end
end
