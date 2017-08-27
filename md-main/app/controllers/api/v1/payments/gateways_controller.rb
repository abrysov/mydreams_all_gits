class Api::V1::Payments::GatewaysController < Api::V1::PurchasesController
  def create
    case params[:gateway]
    when 'appstore'
      ios_inapp_purchase
    when 'googleplay'
      android_inapp_purchase
    else
      render_bad_request
    end
  end

  private

  def ios_inapp_purchase
    receipt_data = params[:receipt_data]

    begin
      gateway = Payment::Gateways::AppStore.new receipt_data

      apple_response = gateway.validating_receipt_with_appstore

      if apple_response.success?
        process = gateway.processing(current_dreamer, params)
        if process.success?
          render_response receipt: apple_response.data, status: 'success',
                          code: 200, message: t('api.success.payment')
        else
          render_bad_request message: 'fail process'
        end
      else
        code = apple_response.data['code']
        render_bad_request code: code,
                           message: t("errors.appstore.receipt_verify.code_#{code}")
      end
    rescue ArgumentError, ActiveRecord::RecordNotFound => error
      render_bad_request message: error.message
    end
  end

  def android_inapp_purchase
    # TODO: android - WIP: send purchase data to v3 api, verify status (0 - purchased)
  end

  def render_bad_request(code: 400, message: nil)
    render json: { meta: { status: 'fail', code: code, message: message } },
           status: :bad_request
  end

  def render_response(receipt:, status:, code:, message: nil)
    render json: {
      receipt: receipt,
      meta: { status: status, code: code, message: message }
    }
  end
end
