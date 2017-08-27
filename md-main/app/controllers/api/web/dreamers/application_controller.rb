class Api::Web::Dreamers::ApplicationController < Api::Web::ApplicationController
  protected

  def dreamer
    @dreamer ||= Dreamer.find(params[:dreamer_id])
  end
end
