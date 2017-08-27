class Api::Web::Profile::DreambookBgsController < Api::Web::Profile::ApplicationController
  def create
    result = SetDreambookBg.new(dreamer: current_dreamer,
                                file: dreambook_required[:file],
                                crop_meta: dreambook_required[:crop]).call

    if result.success?
      render json: {
        meta: { status: 'success', code: 200, message: t('api.v1.profile.dreambook.bg_uploaded') },
        url: { cropped: current_dreamer.dreambook_bg.url(:cropped) }
      }, status: :ok
    else
      render json: {
        meta: { status: 'fail', code: 400, message: t('api.v1.profile.dreambook.bg_not_loaded') }
      }, status: :bad_request
    end
  end

  private

  def dreambook_required
    params.permit(:file, crop: [:x, :y, :width, :height])
  end
end
