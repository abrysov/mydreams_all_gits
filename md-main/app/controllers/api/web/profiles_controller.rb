class Api::Web::ProfilesController < Api::Web::ApplicationController
  before_action :authorize_dreamer!

  def update
    current_dreamer.attributes = profile_params

    if current_dreamer.save
      render json: current_dreamer,
             serializer: DreamerSerializer,
             root: 'profile',
             meta: { status: 'success', code: 200, message: t('api.success.search') },
             status: :ok
    else
      render json: {
        meta: { status: 'fail', code: 422, message: t('api.failure.unprocessable_entity'),
                errors: current_dreamer.errors.full_messages }
      }, status: :unprocessable_entity
    end
  end

  def destroy
    current_dreamer.mark_deleted

    render json: {
      meta: { status: 'success', code: 200, message: t('dreamer.profile_deleted') }
    }, status: :ok
  end

  def restore
    current_dreamer.mark_undeleted

    render json: {
      meta: { status: 'success', code: 200, message: t('dreamer.profile_restored') }
    }, status: :ok
  end

  private

  def profile_params
    params[:dream_city_id] = params.delete :city_id
    params[:dream_country_id] = params.delete :country_id
    params.permit(:first_name, :last_name, :gender, :birthday, :avatar, :dream_city_id,
                  :dream_country_id, :status,
                 :dreambook_bg, :dreambook_bg_crop_x, :dreambook_bg_crop_y, :dreambook_bg_crop_w, :dreambook_bg_crop_h,
                 :avatar, :avatar_crop_x, :avatar_crop_y, :avatar_crop_w, :avatar_crop_h)
  end

  def authorize_dreamer!
    render_forbidden unless dreamer_signed_in?
  end
end
