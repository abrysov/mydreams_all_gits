class Api::V1::ProductsController < Api::V1::ApplicationController
  def inapp
    products = ::Purchases::Products.inapp params[:gateway]

    render json: products,
           each_serializer: ProductSerializer,
           meta: { status: 'success', code: 200 },
           status: :ok
  end

  def index
    products = ::Purchases::Products.fetch params

    render json: products,
           each_serializer: ProductSerializer,
           meta: { status: 'success', code: 200 },
           status: :ok
  end
end
