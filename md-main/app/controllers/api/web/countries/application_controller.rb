class Api::Web::Countries::ApplicationController < Api::Web::ApplicationController
  protected

  def country
    @country ||= DreamCountry.find(params[:country_id])
  end
end
