class Api::Web::Payments::GatewaysController < Api::Web::PurchasesController
  def create
    amount = params[:amount].to_i

    begin
      gateway = Buy::Coins.new params[:gateway]

      redirect_uri = gateway.create(dreamer: current_dreamer, amount: amount).data
    rescue => error
      render_bad_request error
    else
      redirect_to redirect_uri
    end
  end
end
