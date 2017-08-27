class Admin::Management::PurchasesController < Admin::Management::ApplicationController
  def index
    # TODO: order updated_at?
    @purchases = Purchases::Purchases.management(params).
                 preload(:dreamer, :destination_dreamer, :product).
                 page(page).
                 per(per_page)
  end

  def show
    @purchase = Purchase.find params[:id]
  end
end
