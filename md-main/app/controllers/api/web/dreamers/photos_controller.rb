class Api::Web::Dreamers::PhotosController < Api::Web::Dreamers::ApplicationController
  def index
    photos = dreamer.photos.order(id: :desc).page(page).per(per_page)

    render json: photos,
           each_serializer: DreamerPhotoSerializer,
           meta: { status: 'success', code: 200 }.merge(pagination_meta_for(photos)),
           status: :ok
  end
end
