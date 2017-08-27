class Api::V1::Countries::ApplicationController < Api::V1::ApplicationController
  protected

  def country
    @country ||= DreamCountry.find(params[:country_id])
  end
end
