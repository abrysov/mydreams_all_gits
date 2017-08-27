class Api::Web::Profile::CertificatesController < Api::Web::Profile::ApplicationController
  def index
    certificates = Certificates::CertificatesFinder.new(current_dreamer).
                   filter(params).
                   page(page).per(per_page)

    render json: certificates,
           each_serializer: CertificateSerializer,
           meta: { status: 'success', code: 200 }.merge(pagination_meta_for(certificates)),
           status: :ok
  end
end
