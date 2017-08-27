class Api::Web::PostPhotosController < Api::Web::ApplicationController
  def create
    new_post_photo = current_dreamer.post_photos.new(post_photos_params)

    if new_post_photo.save
      render json: new_post_photo,
             serializer: PostPhotoSerializer,
             meta: { status: 'success', code: 200, message: t('api.success.search') },
             status: :ok
    else
      render json: {
        meta: { status: 'fail', code: 422, message: t('api.failure.unprocessable_entity'),
                errors: new_post_photo.errors.full_messages }
      }, status: :unprocessable_entity
    end
  end

  def destroy
    current_dreamer.post_photos.where(id: params[:id]).destroy_all

    render json: { meta: { status: 'success', code: 200, message: t('api.success.destroy') } },
           status: :ok
  end

  private

  def post_photos_params
    params.permit(:post_id, :photo)
  end
end
