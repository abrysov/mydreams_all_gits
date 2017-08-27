class Api::Web::DreamersController < Api::Web::ApplicationController
  def index
    dreamers = ::Dreamers::DreamersFinder.new(dreamer_scope).
               filter(dreamers_params).
               page(page).
               per(per_page).
               includes(:dream_country, :dream_city)

    render json: dreamers, each_serializer: DreamerSerializer,
           meta: { status: 'success', code: 200 }.merge(pagination_meta_for(dreamers)),
           status: :ok
  end

  def show
    dreamer = Dreamer.find_by(id: params[:id])

    if dreamer
      render json: dreamer, serializer: DreamerSerializer, root: :dreamer,
             meta: { status: 'success', code: 200, message: t('api.success.search') }, status: :ok
    else
      render json: { meta: { status: 'fail', code: 404, message: t('api.failure.not_found') } },
             status: :not_found
    end
  end

  private

  def dreamer_scope
    (dreamer_signed_in? ? Dreamer.without(current_dreamer) : Dreamer).not_deleted.not_blocked
  end

  def dreamers_params
    params.permit(:search, :from, :per, :page,
                  :new, :top, :online, :vip,
                  :city_id, :country_id, { age: [ :from, :to ] }, :gender)
  end
end
