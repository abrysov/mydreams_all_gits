class RobokassaController < ApplicationController
  def paid
    if notification.valid_result_signature?
      invoice = ExternalTransaction.find params[:InvId]

      # TODO: fix it
      gateway = Payment::Gateway.new :robokassa
      status = gateway.payment_confirmation invoice, params

      if status.success?
        render text: notification.success
      else
        raven_notify "Invalid result transaction. Invoice #{params[:InvId]}"
        render text: 'Invalid transaction'
      end
    else
      raven_notify "Invalid result signature. Invoice #{params[:InvId]}"
      render text: 'Invalid signature'
    end
  end

  def success
    if notification.valid_success_signature?
      invoice = ExternalTransaction.find params[:InvId]
      # TODO: ???
      invoice.complete?

      redirect_to success_payment_path
    else
      raven_notify "Invalid success signature. Invoice #{params[:InvId]}"

      redirect_to root_url
    end
  end

  def fail
    invoice = ExternalTransaction.pending.find params[:InvId]
    invoice.to_fail!
    Payment::Gateway.new(:robokassa).save_response invoice, params

    # TODO: redirect_path?
    redirect_to fail_payment_path
  end

  private

  def notification
    if request.get?
      Rubykassa::Notification.new request.query_parameters
    elsif request.post?
      Rubykassa::Notification.new request.request_parameters
    end
  end
end
