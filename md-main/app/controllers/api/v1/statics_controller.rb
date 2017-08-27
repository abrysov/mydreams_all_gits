class Api::V1::StaticsController < Api::V1::ApplicationController
  skip_before_action :doorkeeper_authorize!, only: [:terms]

  def terms
    render json: {
      meta: {
        status: 'success',
        code: 200,
        message: t('services.title')
      },
      terms: render_to_string('api/v1/agreement', layout: false)
    },
    status: :ok
  end
end
