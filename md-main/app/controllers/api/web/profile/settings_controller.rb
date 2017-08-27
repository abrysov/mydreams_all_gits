class Api::Web::Profile::SettingsController < Api::Web::Profile::ApplicationController
  def change_email
    if params[:email].present? && current_dreamer.update_attributes(email: params[:email])

      render json: { meta: { status: 'success', code: 200,
                             message: t('devise.confirmations.send_instructions') } },
             status: :ok
    else
      render json: {
        meta: { status: 'fail', code: 422, message: t('api.failure.unprocessable_entity'),
                errors: current_dreamer.errors.full_messages }
      }, status: :unprocessable_entity
    end
  end

  def change_password
    permited_params = password_params
    current_password = permited_params.delete(:current_password)

    status = current_dreamer.valid_password?(current_password) &&
             current_dreamer.update_attributes(permited_params)

    if status
      render json: {
        meta: { status: 'success', code: 200, message: t('devise.confirmations.send_instructions') }
      }, status: :ok
    else
      render json: {
        meta: { status: 'fail', code: 422, message: t('api.failure.unprocessable_entity'),
                errors: current_dreamer.errors.full_messages }
      }, status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.permit(:current_password, :password, :password_confirmation)
  end
end
