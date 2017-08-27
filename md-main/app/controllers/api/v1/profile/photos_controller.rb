class Api::V1::Profile::PhotosController < Api::V1::Profile::ApplicationController
  def index
    photos = current_dreamer.photos.order(id: :desc).page(page).per(per_page)

    render json: photos,
           each_serializer: DreamerPhotoSerializer,
           meta: { status: 'success', code: 200 }.merge(pagination_meta_for(photos)),
           status: :ok
  end

  def create
    new_photo = current_dreamer.photos.new(file: photos_params[:file],
                                           caption: photos_params[:caption])

    if new_photo.save
      render json: new_photo,
             root: :photo,
             serializer: DreamerPhotoSerializer,
             meta: { status: 'success', code: 200, message: t('api.success.create') },
             status: :ok
    else
      render json: {
        meta: { status: 'fail', code: 422, message: t('api.failure.unprocessable_entity'),
                errors: new_photo.errors.full_messages }
      }, status: :unprocessable_entity
    end
  end

  def destroy
    current_dreamer.photos.where(id: params[:id]).destroy_all
    render json: { meta: { status: 'success', code: 200, message: t('api.success.destroy') } },
           status: :ok
  end

  private

  def photos_params
    params.permit(:caption, :file)
  end
end
