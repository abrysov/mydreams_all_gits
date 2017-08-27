class Api::Web::PurchasesController < Api::Web::ApplicationController
  before_action :authorize_dreamer!

  def index
    # TODO: order updated_at?
    purchases = current_dreamer.purchases.order(id: :desc).page(page).per(per_page)

    render json: purchases,
           each_serializer: PurchaseSerializer,
           meta: { status: 'success', code: 200 }.merge(pagination_meta_for(purchases)),
           status: :ok
  end

  protected

  def render_negative_amount(error)
    purchase = error.data.reason.purchase
    render json: purchase,
           serializer: PurchaseSerializer,
           meta: { status: 'fail', code: 402 },
           status: :payment_required
  end

  def render_bad_request(exception, context: {})
    raven_notify exception, context

    render json: { meta: { status: 'fail', code: 400 } },
           status: :bad_request
  end

  def authorize_dreamer!
    render_forbidden unless dreamer_signed_in?
  end
end
