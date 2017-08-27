module Payment
  module Gateways
    class Robokassa
      def self.create_redirect_url(invoice, cost, description)
        redirect_url = Rubykassa.pay_url invoice.id, cost, description: description
        Result::Success.new redirect_url
      end

      def self.save_response(invoice, params)
        params.delete(:controller)
        params.delete(:action)

        invoice.inc_money ||= params[:IncSum]
        invoice.inc_currency ||= params[:IncCurrLabel]
        invoice.out_money ||= params[:OutSum]
        invoice.out_currency ||= params[:OutCurrLabel]
        invoice.response = params.to_json

        invoice.save
      end
    end
  end
end
