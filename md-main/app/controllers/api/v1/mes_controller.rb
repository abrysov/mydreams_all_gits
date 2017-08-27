class Api::V1::MesController < Api::V1::ApplicationController
  def show
    render json: current_dreamer, serializer: CurrentDreamerSerializer,
           root: :dreamer,
           meta: { status: 'success', code: 200 },
           status: :ok
  end
end
