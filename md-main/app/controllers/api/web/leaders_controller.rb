class Api::Web::LeadersController < Api::Web::ApplicationController
  before_filter :authenticate_dreamer!, only: [:create]

  def index
    dreamers = Dreamer.for_photobar.
               preload(:dream_city, :dream_country).
               limit(params[:limit].present? ? params[:limit].to_i : 40)

    render json: dreamers,
           root: :leaders,
           each_serializer: DreamerPhotobarSerializer,
           meta: { status: 'success', code: 200 },
           status: :ok
  end

  def create
    if dreamer_signed_in?
      current_dreamer.photobar_added_at = Time.now
      current_dreamer.photobar_added_photo_id = params[:photo_id]
      current_dreamer.photobar_added_text = params[:message]
      current_dreamer.save(validates: false)

      render json: current_dreamer,
             root: :dreamer_photobar,
             serializer: DreamerPhotobarSerializer,
             meta: { status: 'success', code: 200 },
             status: :ok
    else
      head 403
    end
  end
end
