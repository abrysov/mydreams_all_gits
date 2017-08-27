class ApplicationController < ActionController::Base
  include MethodsForNewDesign
  include ApplicationHelper
  include VideoHelper

  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token

  before_action :set_new_views_for_admin
  before_action :set_locale
  unless Rails.env.test?
    before_action :check_if_active
    # TODO: remove this when messenger will be released. See MYD-385
    before_action :set_last_reload
  end

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_last_viewed_news_time
  before_action :set_raven_user, if: :dreamer_signed_in?

  rescue_from ActiveRecord::RecordNotFound do
    redirect_to root_path
  end
  rescue_from ActionController::RedirectBackError do
    redirect_to root_url
  end

  protected

  def set_last_viewed_news_time
    if current_dreamer && current_dreamer.last_news_viewed_at.nil?
      current_dreamer.update_last_viewed_news_time
    end
  end

  def seo_meta(metas = {})
    metas.each do |k, v|
      set_meta_tags(k => v)
    end
  end

  def opengraph_meta(obj)
    seo_meta og: { title: obj.title, url: request.url }

    if obj.photo.present?
      seo_meta og: { image: obj.photo.url(:large) }
    end
  end

  def check_if_active
    return if params[:controller] == 'sessions' && params[:action] == 'destroy'
    if dreamer_signed_in? && !current_dreamer.active?
      if current_dreamer.blocked?
        render 'dreamers/blocked', layout: for_new_design? ? 'application_light' : 'empty_layout'
      elsif current_dreamer.deleted?
        render 'dreamers/deleted', layout: for_new_design? ? 'application_light' : 'empty_layout'
      elsif !current_dreamer.confirmed?
        redirect_to new_dreamer_confirmation_path
      end
      return false
    end
  end

  def load_dreamer
    @dreamer = params[:dreamer_id].present? && !current_dreamer_id?(params[:dreamer_id]) ? Dreamer.find(params[:dreamer_id]).decorate : current_dreamer
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :password, :remember_me) }
  end

  private

  # TODO: remove this when messenger will be released. See MYD-385
  def set_last_reload
    current_dreamer.update_column(:last_reload_at, Time.zone.now) if dreamer_signed_in?
  end

  def set_locale
    I18n.locale = params[:locale] ||
      http_accept_language.compatible_language_from(I18n.available_locales) ||
      I18n.default_locale
  end

  def default_url_options(options = {})
    options.merge! locale: I18n.locale
  end

  def after_sign_out_path_for(_resource_or_scope)
    root_path
  end

  def after_sign_in_path_for(resource_or_scope)
    if resource_or_scope.is_a?(Dreamer) && resource_or_scope.role == 'admin'
      admin_root_path
    else
      account_dreamer_path(current_dreamer)
    end
  end

  def request_entity
    case params.symbolize_keys[:entity_type]
    when /^dream$/i      then Dream
    when /^comment$/i    then Comment
    when /^photo$/i      then Photo
    when /^post$/i       then Post
    when /^top_?dream$/i then TopDream
    end
  end

  def request_entity_object
    request_entity.unscoped.find(params.symbolize_keys[:entity_id])
  end

  def restricted_request_entity_object
    if request_entity
      request_entity.not_deleted.all_for(current_dreamer).find(params.symbolize_keys[:entity_id])
    end
  end

  def current_dreamer
    @decorated_current_dreamer ||= DreamerDecorator.decorate(super) if super
  end

  def current_user
    current_dreamer
  end

  def current_dreamer?(dreamer)
    dreamer_signed_in? && current_dreamer == dreamer
  end
  helper_method :current_dreamer?

  def current_dreamer_id?(id)
    dreamer_signed_in? && current_dreamer.id == id.to_i
  end
  helper_method :current_dreamer_id?

  def signed_by_not?(dreamer)
    dreamer_signed_in? && current_dreamer.id != dreamer.id
  end
  helper_method :signed_by_not?

  def set_raven_user
    Raven.user_context id: current_dreamer.id, email: current_dreamer.email
  end

  def raven_notify(exception, context = nil)
    if exception.is_a? String
      Raven.capture_message 'Error: raven_notify',
                            logger: 'mydreams',
                            extra: {
                              message: exception,
                              context: context
                            },
                            tags: { environment: Rails.env }
    elsif exception.is_a? Result::Error
      Raven.capture_message 'Error: raven_notify',
                            logger: 'mydreams',
                            extra: {
                              message: exception.message,
                              context: context
                            },
                            tags: { environment: Rails.env }
    else
      Raven.capture_exception exception
    end
  end
end
