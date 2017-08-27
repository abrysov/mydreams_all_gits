class Admin::Management::LockedsController < Admin::Management::ApplicationController
  def index
    @products = Purchases::Products.management(params, Product.locked).
                page(page).
                per(per_page)
  end
end
