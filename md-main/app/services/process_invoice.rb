class ProcessInvoice
  attr_reader :invoice, :session

  def initialize(invoice, session)
    @invoice = invoice
    @session = session
  end

  def call
    case
    when invoice.vip?
      invoice.dreamer.update_attribute(:is_vip, true)
    when invoice.certificate?
      invoice.payable.update_attribute(:paid, true)
      session[:order_id]   = invoice.id
      session[:order_type] = 'certificate'
    else
      fail "Unknown invoice type. Invoice #{invoice.id}"
    end

    create_activity(invoice)
    touch_dream_paid_date(invoice)
    invoice.success!
  end

  def self.call(*args)
    new(*args).call
  end

  private

  def touch_dream_paid_date(invoice)
    payable = invoice.payable
    payable.update(last_paid_at: Time.now) if payable.is_a?(Dream)
  end

  def create_activity(invoice)
    key = case invoice.payment_type
          when Invoice::VIP_SELF_TYPE
            'paid_self_vip'
          when Invoice::VIP_GIFT_TYPE
            'paid_gift_vip'
          when Invoice::CERTIFICATE_TYPE
            if invoice.payable.gifted_by_id
              'paid_gift_certificate'
            else
              'paid_self_certificate'
            end
          end
    trackable = invoice.payable if invoice.payment_type == Invoice::CERTIFICATE_TYPE
    Feed::Activity::Create.call(trackable: trackable,
                                owner: invoice.dreamer, # not current if type = gift
                                key: key)
  end
end
