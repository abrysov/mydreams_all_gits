class MailgunWebhooksController < ActionController::Base
  def complain
    run_event_processing('complained')
  end

  def unsubscribe
    run_event_processing('unsubscribed')
  end

  def bounce
    run_event_processing('bounced')
  end

  private

  def run_event_processing(event)
    if MailgunWebhookService.process_event(event, params)
      head 200
    else
      head 406
    end
  end
end
