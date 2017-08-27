class InvoicesController < ApplicationController
  before_action :authenticate_dreamer!, only: [:buy_vip, :certificate_self]

  def buy_vip
    @invoice = Invoice.new(
      dreamer: current_dreamer,
      description: 'VIP status',
      payment_type: Invoice::VIP_SELF_TYPE
    )
    @invoice.total = CalculateInvoiceTotal.call @invoice

    save_and_redirect
  end

  def gift_vip
    dreamer = Dreamer.find params[:dreamer_id]
    @invoice = Invoice.new(
      dreamer: dreamer,
      description: 'VIP status gift',
      payment_type: Invoice::VIP_GIFT_TYPE
    )
    @invoice.total = CalculateInvoiceTotal.call(@invoice, current_dreamer: current_dreamer)

    save_and_redirect
  end

  # TODO: rename to 'buy_certificate' and change HTTP method to POST
  def certificate_self
    payable = params[:payable_type].constantize.find params[:payable_id]
    @invoice = Invoice.new(
      dreamer: current_dreamer,
      payable: payable,
      description: 'buy certificate',
      payment_type: Invoice::CERTIFICATE_TYPE
    )
    @invoice.total = CalculateInvoiceTotal.call(@invoice, current_dreamer: current_dreamer)

    save_and_redirect
  end

  private

  def save_and_redirect
    @invoice.redirect_path = params[:redirect_path].presence || root_path

    if @invoice.save
      if current_dreamer.is_project_dreamer?
        ProcessInvoice.call @invoice, session
        redirect_to @invoice.redirect_path
      else

        yandex_kassa = YandexKassa.new(invoice: @invoice, api: container[:yandex_kassa_api_klass],
                                       helpers: container[:yandex_kassa_helpers_klass])
        location = yandex_kassa.pay_redirect_location

        if location
          redirect_to location
        else
          head :bad_request
        end
      end
    else
      render text: 'Invoice can not been saved.'
    end
  end
end
