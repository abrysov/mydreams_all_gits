class Account::CertificatesController < ApplicationController
  before_filter :load_dreamer, only: [:index]

  def index
    gifted_certificates

    @new_certificate_type = certificate_type_for params[:new_certificate]
    @certificates = Certificate.paid.
                    where(certifiable_type: 'Dream').
                    where(certifiable_id: @dreamer.dreams.pluck(:id)).
                    where(accepted: true).
                    page(params[:page]).per(25)

    if params[:paginator]
      render partial: 'account/certificates/certificates'
    else
      render layout: (request.xhr? ? false : 'flybook')
    end
  end

  def create
    build_certificate

    if @certificate.gifted_by_id.nil?
      @certificate.accepted = true
    end

    respond_to do |format|
      format.html do
        if @certificate.save
          redirect_to [
            :certificate_self,
            :invoices,
            payable_id: @certificate.id,
            payable_type: 'Certificate',
            redirect_path: redirect_with_video_cpath(request.env['PATH_INFO'], @certificate)
          ]
        else
          render json: { errors: @certificate.errors }
        end
      end
    end
  end

  def accept
    @certificate = gifted_certificates.find(params[:certificate_id])
    @certificate.update(accepted: true)

    redirect_to account_dreamer_certificates_url(current_dreamer)
  end

  def show_gifted_certificates
    gifted_certificates

    render partial: 'account/certificates/all_gifted_certificates', layout: false
  end

  private

  def gifted_certificates
    load_dreamer
    @gifted_certificates ||= Certificate.paid.
                             where(certifiable_type: 'Dream').
                             where(certifiable_id: @dreamer.dreams.pluck(:id)).
                             where.not(gifted_by_id: nil).
                             where(accepted: false)
  end

  def build_certificate
    @certificate ||= Certificate.new
    @certificate.attributes = certificate_params
  end

  def certificate_params
    return {} if params[:certificate].blank?
    params.require(:certificate).permit(:certificate_type_id,
                                        :gifted_by_id,
                                        :certifiable_id,
                                        :certifiable_type,
                                        :wish)
  end
end
