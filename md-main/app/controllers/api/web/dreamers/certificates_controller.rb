class Api::Web::Dreamers::CertificatesController < Api::Web::Dreamers::ApplicationController
  def index
    certificates = Certificates::CertificatesFinder.new(dreamer).
                   filter(params).
                   page(page).per(per_page)

    render json: certificates,
           each_serializer: CertificateSerializer,
           meta: { status: 'success', code: 200 }.merge(pagination_meta_for(certificates)),
           status: :ok
  end
end
