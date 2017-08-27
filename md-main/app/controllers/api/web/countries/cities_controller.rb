class Api::Web::Countries::CitiesController < Api::Web::Countries::ApplicationController
  def index
    dream_cities = if cities_params[:q]
                     ProcessDreamCity.search_dream_cities(
                       name: cities_params[:q],
                       country_id: country.id
                     )
                   else
                     DreamCity.where(dream_country_id: country.id).limit(50)
                   end

    if dream_cities && dream_cities.any?
      render json: dream_cities, root: :cities,
             meta: { status: 'success', code: 200, message: t('api.success.search') }, status: :ok
    else
      render json: { meta: { status: 'fail', code: 404, message: t('api.failure.not_found') } },
             status: :not_found
    end
  end

  def create
    create_params = {
      country_id: country.id,
      city_name: cities_params[:city_name],
      region_name: cities_params[:region_name],
      district_name: cities_params[:district_name]
    }

    dream_city = ProcessDreamCity.create_dream_city(create_params)
    if dream_city
      render json: dream_city, root: :city,
             meta: { status: 'success', code: 201, message: t('api.success.create') },
             status: :created
    else
      render json: { meta: { status: 'fail', code: 422,
                             message: t('api.failure.unprocessable_entity') } },
             status: :unprocessable_entity
    end
  end

  private

  def cities_params
    params.permit(:q, :region_name, :district_name, :city_name)
  end
end
