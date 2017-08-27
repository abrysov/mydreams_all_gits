class YandexkassaController < ApplicationController
  def check
    yandex_kassa = YandexKassa.new(action: 'checkOrder', params: params,
                                   api: container[:yandex_kassa_api_klass],
                                   helpers: container[:yandex_kassa_helpers_klass])
    render plain: yandex_kassa.check_order_response
  end

  def aviso
    yandex_kassa = YandexKassa.new(action: 'paymentAviso', params: params,
                                   api: container[:yandex_kassa_api_klass],
                                   helpers: container[:yandex_kassa_helpers_klass])
    render plain: yandex_kassa.payment_aviso_response(session)
  end

  def success
    invoice = Invoice.find_by(id: params[:orderNumber]) if params[:orderNumber]

    if invoice
      redirect_to invoice.redirect_path
    else
      redirect_to root_url
    end
  end

  def failed
    if params[:orderNumber]
      invoice = Invoice.pending.find_by(id: params[:orderNumber])
      invoice.fail

      redirect_to invoice.redirect_path
    else
      redirect_to root_url
    end
  end
end
