class Moderate::ComplainsController < Moderate::ApplicationController
  def index
    @complains = Complain.includes(:complainable).page params[:page]
  end
end
