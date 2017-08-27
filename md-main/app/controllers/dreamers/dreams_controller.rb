class Dreamers::DreamsController < Dreamers::ApplicationController
  def index
  end

  def show
    gon.dreamer_id = params[:dreamer_id]
    gon.dream_id = params[:id]
  end
end
