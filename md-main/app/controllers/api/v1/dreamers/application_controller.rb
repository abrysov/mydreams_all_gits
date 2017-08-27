class Api::V1::Dreamers::ApplicationController < Api::V1::ApplicationController
  protected

  def dreamer
    @dreamer ||= Dreamer.find(params[:dreamer_id])
  end
end
