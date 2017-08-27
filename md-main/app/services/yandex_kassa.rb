class YandexKassa
  SHOP_ID = Dreams.config.secret.payments.yandex_kassa.shopId
  SC_ID = Dreams.config.secret.payments.yandex_kassa.scid
  SECRET = Dreams.config.secret.payments.yandex_kassa.secret
  URL = Dreams.config.secret.payments.yandex_kassa.url

  def initialize(invoice: nil, params: nil, action: nil, api: nil, helpers: nil)
    @invoice = invoice
    @params = params
    @action = action
    @yandex_api = api
    @yandex_helpers = helpers
  end

  def pay_redirect_location
    post_params = build_post_params
    @yandex_api.pay_redirect_location(URL, post_params)
  end

  def check_order_response
    if @yandex_helpers.check_md5(@action, @params, SECRET) && @params[:orderNumber]
      invoice = Invoice.find(@params[:orderNumber])
      status = if check_order(invoice)
                 Rails.logger.info 'YandexKassa: Success check order'
                 status_code(:success)
               else
                 Rails.logger.info 'YandexKassa: Fail check order'
                 status_code(:cancel_accept)
               end
    else
      Rails.logger.info 'YandexKassa: Wrong md5'
      status = status_code(:fail_auth)
    end

    Rails.logger.info "YandexKassa: Response with code #{status}"
    @yandex_helpers.build_response(@action, status, @params[:invoiceId], SHOP_ID)
  end

  def payment_aviso_response(session)
    status = if @yandex_helpers.check_md5(@action, @params, SECRET)
               make_invoice_paid(session)
               status_code(:success)
             else
               status_code(:fail_auth)
             end
    @yandex_helpers.build_response(@action, status, @params[:invoiceId], SHOP_ID)
  end

  private

  def build_post_params
    return unless @invoice
    {
      'shopId' => SHOP_ID,
      'scid' => SC_ID,
      'customerNumber' => @invoice.dreamer_id,
      'sum' => @invoice.amount.to_f,
      'orderNumber' => @invoice.id
    }
  end

  def check_order(invoice)
    return unless invoice

    @params[:orderSumAmount].to_f == invoice.amount.to_f &&
      @params[:customerNumber].to_i == invoice.dreamer_id &&
      @params[:shopId].to_i == SHOP_ID.to_i &&
      @params[:scid].to_i == SC_ID.to_i
  end

  def make_invoice_paid(session)
    invoice = Invoice.find_by(id: @params[:orderNumber])
    ProcessInvoice.call(invoice, session) if invoice
  end

  def status_code(status)
    @yandex_helpers.class::STATUS_CODE[status]
  end
end
