class Api::V1::ProfilesController < Api::V1::ApplicationController
  skip_before_action :api_check_access, only: :restore

  def update
    current_dreamer.attributes = profile_params

    if current_dreamer.save
      render json: current_dreamer,
             serializer: ShortDreamerSerializer,
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
                  :dream_country_id, :status)
  end
end
