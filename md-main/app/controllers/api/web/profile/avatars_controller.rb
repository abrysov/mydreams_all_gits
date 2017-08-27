class Api::Web::Profile::AvatarsController < Api::Web::Profile::ApplicationController
  def create
    success = SetDreamerAvatar.new(dreamer: current_dreamer,
                                   file: avatar_required[:file],
                                   cropped_file: avatar_required[:cropped_file],
                                   crop_meta: avatar_required[:crop]).call

    if success
      render json: current_dreamer.current_avatar,
             serializer: AvatarSerializer,
             meta: { status: 'success', code: 200, message: t('api.v1.profile.avatar.uploaded') },
             status: :ok
    else
      render json: {
        meta: { status: 'fail', code: 422, message: t('api.failure.unprocessable_entity') }
      }, status: :unprocessable_entity
    end
  end

  def destroy
    if current_dreamer.current_avatar_id == params[:id]
      ActiveRecord::Base.transaction do
        current_dreamer.avatars.where(id: params[:id]).destroy_all
        current_dreamer.avatar.remove!
        current_dreamer.update_attributes(current_avatar_id: 0)
      end
    else
      current_dreamer.avatars.where(id: params[:id]).destroy_all
    end

    render json: { meta: { status: 'success', code: 200, message: t('api.success.destroy') } },
           status: :ok
  end

  private

  def avatar_required
    params.permit(:file, :cropped_file, crop: [:x, :y, :width, :height])
  end
end
