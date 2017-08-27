class Api::V1::Purchases::VipStatusesController < Api::V1::PurchasesController
  def create
    dreamer = Dreamer.find params[:destination_id]
    product = Product.find params[:product_id]
    comment ||= params[:comment]

    begin
      status = Buy::VipStatus.new.create(
        dreamer: current_dreamer,
        product: product,
        destination: dreamer,
        comment: comment
      )
    rescue NegativeAmountError => error
      render_negative_amount error
    rescue => error
      render_bad_request error
    else
      render_vip status
    end
  end

  def update
    purchase = Purchase.find params[:id]
    unless purchase.dreamer == current_dreamer
      raise ArgumentError, 'Expected another buyer'
    end

    begin
      status = Buy::VipStatus.new(purchase).processing
    rescue NegativeAmountError => error
      render_negative_amount error
    rescue => error
      render_bad_request error
    else
      render_vip status
    end
  end

  def render_vip(status)
    if status.success?
      vip = status.data
      render json: vip, serialize: VipStatusSerializer,
             meta: { status: 'success', code: 200 },
             status: :ok
    else
      render_bad_request status, context: { errors: status.errors, data: status.data }
    end
  end
end
