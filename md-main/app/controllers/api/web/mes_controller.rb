class Api::Web::MesController < Api::Web::ApplicationController
  def show
    render json: current_dreamer,
           serializer: CurrentDreamerSerializer,
           root: :dreamer,
           meta: { status: 'success', code: 200 },
           status: :ok
  end
end
