class Api::V1::Dreamers::DreamsController < Api::V1::Dreamers::ApplicationController
  def index
    dreams = Dreams::DreamsFinder.new(dreamer.dreams).
             filter(params, current_dreamer).
             page(page).per(per_page)

    render json: dreams,
           meta: { status: 'success', code: 200 }.merge(pagination_meta_for(dreams)),
           status: :ok
  end
end
