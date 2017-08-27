class DreamerCitiesController < ApplicationController
  def index
    cities = params[:country_id].present? ? DreamCity.filter(params).order("name") : []

    render json: cities, root: false
  end
end
