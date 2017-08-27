class Api::Web::Profile::DreamsController < Api::Web::Profile::ApplicationController
  def index
    dreams = Dreams::DreamsFinder.new(current_dreamer.dreams).
             filter(params, current_dreamer).
             page(page).per(per_page)

    render json: dreams,
           meta: { status: 'success', code: 200 }.merge(pagination_meta_for(dreams)),
           status: :ok
  end
end
