class Api::Web::Purchases::CertificatesController < Api::Web::PurchasesController
  def create
    dream = Dream.find params[:destination_id]
    product = Product.find params[:product_id]
    comment ||= params[:comment]

    begin
      status = Buy::Certificates.new.create(
        dreamer: current_dreamer,
        product: product,
        destination: dream,
        comment: comment
      )
    rescue NegativeAmountError => error
      render_negative_amount error
    rescue => error
      render_bad_request error
    else
      render_certificate status
    end
  end

  def update
    purchase = Purchase.find params[:id]
    unless purchase.dreamer == current_dreamer
      raise ArgumentError, 'Expected another buyer'
    end

    begin
      status = Buy::Certificates.new(purchase).processing
    rescue NegativeAmountError => error
      render_negative_amount error
    rescue => error
      render_bad_request error
    else
      render_certificate status
    end
  end

  def render_certificate(status)
    if status.success?
      certificate = status.data
      render json: certificate, serialize: CertificateSerializer,
             meta: { status: 'success', code: 200 },
             status: :ok
    else
      render_bad_request status, context: { errors: status.errors, data: status.data }
    end
  end
end
