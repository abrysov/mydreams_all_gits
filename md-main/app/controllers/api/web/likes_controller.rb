class Api::Web::LikesController < Api::Web::ApplicationController
  def index
    likes = restricted_request_entity_object.likes.page(page).per(per_page)

    render json: likes,
           each_serializer: LikeSerializer,
           meta: { status: 'success', code: 200 }.merge(pagination_meta_for(likes)),
           status: :ok
  end

  def create
    like = current_dreamer.likes.find_or_create_by(likeable: request_entity_object)

    if like.valid?
      render json: like,
             meta: { status: 'success', code: 200 },
             status: :ok
    else
      render json: { meta: { status: 'fail', code: 400 } },
             status: :bad_request
    end
  end

  def destroy
    params[:entity_id] = params[:id]

    current_dreamer.likes.where(likeable: request_entity_object).destroy_all

    render json: { meta: { status: 'success', code: 200 } }, status: :ok
  end
end
