class Api::V1::ApplicationController < Api::ApplicationController
  before_action :doorkeeper_authorize!
  before_action :api_locale
  before_action :api_check_access
  skip_before_action :check_if_active
  respond_to :json

  protected

  def api_locale
    I18n.locale = params[:locale] ||
                  http_accept_language.compatible_language_from(I18n.available_locales) ||
                  I18n.default_locale
  end

  def api_check_access
    if dreamer_signed_in? && !(current_dreamer.deleted_at.nil? && current_dreamer.blocked_at.nil?)
      render json: {
        meta: {
          status: 'fail', code: 403,
          message: t('api.failure.forbidden') },
          id: @current_dreamer.id,
          is_blocked: @current_dreamer.blocked_at.present?,
          is_deleted: @current_dreamer.deleted_at.present?
      }, status: :forbidden
    end
  end

  def current_dreamer
    @current_dreamer ||= Dreamer.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def doorkeeper_unauthorized_render_options(error: nil)
    {
      json: {
        meta: {
          status: 'fail',
          code: 401,
          message: 'Not authorized!'
        }
      },
      status: :unauthorized
    }
  end
end
