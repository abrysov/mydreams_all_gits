class Api::V1::DreamersController < Api::V1::ApplicationController
  skip_before_action :doorkeeper_authorize!, only: [:create]

  def index
    dreamers = Dreamers::DreamersFinder.new(dreamer_scope).
               filter(dreamers_params).
               page(page).
               per(per_page).
               includes(:dream_country, :dream_city)

    render json: dreamers, each_serializer: DreamerSerializer,
           meta: { status: 'success', code: 200 }.merge(pagination_meta_for(dreamers)),
           status: :ok
  end

  def create
    @user_data = dreamer_params
    dreamer_form = NewDreamerForm.new(@user_data)

    if dreamer_form.valid?
      dreamer = RegisterDreamer.call(@user_data)
      render json: dreamer, serializer: CurrentDreamerSerializer, root: :dreamer, meta: {
        status: 'success',
        code: 201,
        message: t('devise.registrations.signed_up')
      },
      status: :created
    else
      render json: {
        meta: {
          status: 'fail', code: 422, message: t('devise.registrations.validation_failed'),
          errors: dreamer_form.errors
        }
      },
      status: :unprocessable_entity
    end
  end

  def show
    dreamer = Dreamer.find_by(id: params[:id])

    if dreamer
      render json: dreamer, serializer: DreamerSerializer, root: :dreamer,
             meta: { status: 'success', code: 200, message: t('api.success.search') }, status: :ok
    else
      render json: { meta: { status: 'fail', code: 404, message: t('api.failure.not_found') } },
             status: :not_found
    end
  end

  private

  def dreamer_scope
    (dreamer_signed_in? ? Dreamer.without(current_dreamer) : Dreamer).not_deleted.not_blocked
  end

  def dreamer_params
    params[:dream_city_id] = params[:city_id]
    params[:dream_country_id] = params[:country_id]

    params.permit(:email, :password, :first_name, :last_name, :birthday, :gender, :phone,
                  :dream_country_id, :dream_city_id)
  end

  def dreamers_params
    params[:age] = {} if params[:age].blank?
    params[:age].update(from: params[:age_from]) if params[:age_from].present?
    params[:age].update(to: params[:age_to]) if params[:age_to].present?

    params.permit(:search, :from, :per, :page,
                  :new, :top, :online, :vip,
                  :city_id, :country_id, { age: [ :from, :to ] }, :gender)
  end
end
