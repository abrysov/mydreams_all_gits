class Api::V1::Profile::RestoresController < Api::V1::Profile::ApplicationController
  skip_before_action :api_check_access, only: [:create]

  def create
    current_dreamer.restore!
    render json: {
      meta: {
        status: 'success',
        code: 200,
        message: t('flash.success.restored')
      }
    }, status: :ok
  end
end
