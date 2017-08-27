class Dreamers::ApplicationController < ApplicationController
  before_action do
    gon.dreamer = DreamerSerializer.new(dreamer)
  end

  protected

  def dreamer
    @dreamer ||= Dreamer.find(params[:dreamer_id] || params[:id]).decorate
  end
  helper_method :dreamer

end
