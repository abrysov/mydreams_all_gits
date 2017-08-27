class Api::V1::CountriesController < Api::V1::ApplicationController
  skip_before_action :doorkeeper_authorize!, only: [:index, :create]

  def index
    query = countries_params[:q]
    dream_countries = if query
                        DreamCountry.search_by_name(capitalize_words(query)).limit(50)
                      else
                        DreamCountry.all
                      end

    if dream_countries && dream_countries.any?
      render json: dream_countries, root: :countries,
             meta: { status: 'success', code: 200, message: t('api.success.search') }, status: :ok
    else
      render json: { meta: { status: 'fail', code: 404, message: t('api.failure.not_found') } },
             status: :not_found
    end
  end

  private

  def countries_params
    params.permit(:q)
  end
end
