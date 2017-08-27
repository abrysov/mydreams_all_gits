class Admin::Management::ProductsController < Admin::Management::ApplicationController
  def index
    @products = Purchases::Products.management(params, Product.active).
                page(page).
                per(per_page)
  end

  def new
  end

  def create
    product = Product.create product_params

    if product.persisted?
      unless params[:properties].blank?
        properties = params[:properties]
        properties.each do |property|
          ProductProperty.create product: product, key: property[:key], value: property[:value]
        end
      end

      log_action! logable: product

      redirect_to admin_management_product_path product
    else
      render plain: product.errors.to_json
    end
  end

  def show
    @product = Product.find params[:id]
  end

  def edit
    @product = Product.find params[:id]
  end

  def update
    product = Product.find params[:id]

    product.transaction do
      product.lock! unless product.locked?
      @new_product = Product.create product_params
    end

    if @new_product.persisted?
      unless params[:properties].blank?
        properties = params[:properties] << { key: 'previous_id', value: product.id }
        properties.each do |property|
          ProductProperty.create product: @new_product, key: property[:key], value: property[:value]
        end

        ProductProperty.create product: product, key: 'new_id', value: @new_product.id
      end

      # TODO: old product?
      log_action! logable: product

      redirect_to admin_management_product_path @new_product
    else
      render plain: @new_product.errors.to_json
    end
  end

  def destroy
    product = Product.find params[:id]
    if product.active?
      product.lock!

      log_action! logable: product, action: 'lock'
    else
      product.activate!

      log_action! logable: product, action: 'activate'
    end

    redirect_to admin_management_product_path product
  end

  protected

  def render_bad_request
    render json: { meta: { status: 'fail', code: 400 } },
           status: :bad_request
  end

  def product_params
    params.permit(:name, :product_type, :cost)
  end
end
