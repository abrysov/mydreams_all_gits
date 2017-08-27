class Dreamers::FolloweesController < Dreamers::ApplicationController
  def index
    if current_dreamer.id != dreamer.id
      redirect_to d_path(dreamer)
    end
  end
end
