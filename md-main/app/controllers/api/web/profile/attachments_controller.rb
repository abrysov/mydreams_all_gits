class Api::Web::Profile::AttachmentsController < Api::Web::Profile::ApplicationController
  rescue_from Net::OpenTimeout, Net::ReadTimeout, with: :timeout_error

  before_action :require_file_or_url

  def create
    attachment = CreateAttachment.new(file: attachment_required[:file],
                                      url: attachment_required[:url]).call
    render json: attachment,
           serializer: AttachmentSerializer
  end

  private

  def attachment_required
    params.permit(:file, :url)
  end

  def timeout_error(error)
    raven_notify error
    render_unprocessable_entity
  end

  def require_file_or_url
    render_unprocessable_entity if params[:file].blank? && params[:url].blank?
  end
end
