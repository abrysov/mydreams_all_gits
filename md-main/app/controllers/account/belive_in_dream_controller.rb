class Account::BeliveInDreamController < ApplicationController
  before_action :authenticate_dreamer!

  def new
    @dream = Dream.new

    if session[:order_id].present?
      session.delete :order_type
      invoice = Invoice.find(session.delete :order_id)
      @certificate_name = invoice.payable.certificate_type.name
    end
  end
end
