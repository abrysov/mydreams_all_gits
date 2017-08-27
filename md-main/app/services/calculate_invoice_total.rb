class CalculateInvoiceTotal
  SPECIAL_DREAMERS = ['jetblackmeerkat@gmail.com']

  attr_accessor :invoice

  def initialize(invoice, current_dreamer: nil)
    @invoice = invoice
    @current_dreamer = current_dreamer
  end

  def call
    case invoice.payment_type
    when Invoice::VIP_SELF_TYPE, Invoice::VIP_GIFT_TYPE
      vip_price_for invoice.dreamer
    when Invoice::CERTIFICATE_TYPE
      certificate_price_for invoice.payable, invoice.dreamer
    end
  end

  def self.call(*args)
    new(*args).call
  end

  private

  def vip_price_for(dreamer)
    return 1 if special_dreamer(dreamer)

    Setting.vip_status_price
  end

  def certificate_price_for(certificate, dreamer)
    return 1 if special_dreamer(dreamer)

    Setting.certificate_price * certificate_price_coefficient(certificate)
  end

  def certificate_price_coefficient(certificate)
    certificate.certificate_type.value
  end

  def special_dreamer(dreamer)
    return true if SPECIAL_DREAMERS.include?(dreamer.email) || @current_dreamer.try(:is_project_dreamer?)
  end
end
