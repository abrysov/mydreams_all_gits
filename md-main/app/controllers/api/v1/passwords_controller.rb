class Api::V1::PasswordsController < Api::V1::ApplicationController
  skip_before_action :doorkeeper_authorize!, only: [:reset]

  def reset
    if dreamer_reset = Dreamer.where('lower(email) = lower(?)', params[:email]).first
      dreamer_reset.send_reset_password_instructions
      render json: {
        meta: {
          status: 'success',
          code: 200,
          message: t('devise.confirmations.send_instructions')
        }
      },
      status: :ok
    else
      render json: {
        meta: {
          status: 'fail',
          code: 400,
          message: t('devise.confirmations.instructions_not_sent')
        }
      },
      status: :bad_request
    end
  end
end
