class DreamersController < ApplicationController
  before_filter :authenticate_dreamer!, except: [:index, :create, :social_login]

  def index
    unless for_new_design?
      @dreamers = Dreamers::DreamersFinder.new(dreamer_scope).
                  filter(params).
                  where.not(project_dreamer: true).
                  order('avatar IS NULL').
                  order(id: :desc).
                  page(params[:page]).
                  per(16).
                  includes(:dream_country, :dream_city)

      if request.xhr?
        render partial: 'dreamers/dreamers'
      end
    end
  end

  def create
    dreamer_form = NewDreamerForm.new(dreamer_params)

    if dreamer_form.valid?
      dreamer = RegisterDreamer.call(dreamer_params)
      sign_in dreamer
      render json: { id: dreamer.id }
    else
      render json: { errors: dreamer_form.errors }, status: :unprocessable_entity
    end
  end

  def show
    gon.dreamer_id = params[:id]
  end

  def social_login
    dreamer = ProviderAuth.call request.env['omniauth.auth'], current_dreamer
    sign_in dreamer

    redirect_to account_dreamer_dreams_path(dreamer.id)
  end

  private

  def set_city
    filter_city_id = params[:filter].try(:[], :dream_city_id)
    if filter_city_id
      session[:current_city] = filter_city_id
    elsif dreamer_signed_in?
      city_name = ::GeoipLocator.new(current_user.current_sign_in_ip).city_name
      session[:current_city] = DreamCity.search_by_name(city_name).first
    end

    @current_city = DreamCity.find_by(id: session[:current_city])
  end

  def set_country
    filter_country_id = params[:filter].try(:[], :dream_country_id)
    if filter_country_id
      session[:current_country] = filter_country_id
    elsif dreamer_signed_in?
      country_name = ::GeoipLocator.new(current_user.current_sign_in_ip).country_name
      session[:current_country] = DreamCountry.search_by_name(country_name).first
    end

    @current_country = DreamCountry.find_by(id: session[:current_country])
  end

  def dreamer
    @dreamer ||= Dreamer.find(params[:id]).decorate
  end
  helper_method :dreamer

  def dreamer_scope
    (dreamer_signed_in? ? Dreamer.without(current_dreamer) : Dreamer).not_deleted.not_blocked
  end

  def build_dreamer
    @dreamer ||= dreamer_scope.build
    @dreamer.attributes = dreamer_params
    # @dreamer.avatar = nil if dreamer_params[:remove_avatar].present?
  end

  def apply_redirect(notice = '')
    redirect_to dreamer_signed_in? ? account_dreamer_path(current_dreamer) : dreamers_path, notice: notice
  end

  def dreamer_params
    return {} if params[:dreamer].blank?
    params.require(:dreamer).permit(:email, :password, :password_confirmation, :birthday, :gender,
                                    :phone, :first_name, :last_name, :provider, :uid, :oauth_token,
                                    :oauth_expires_at, :avatar, :avatar_cache, :remove_avatar,
                                    :dream_country_id, :dream_city_id)
  end
end
