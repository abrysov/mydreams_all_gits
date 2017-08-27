class Api::Web::ProductsController < Api::Web::ApplicationController
  def index
    return render_forbidden unless dreamer_signed_in?

    products = ::Purchases::Products.fetch params

    render json: products,
           each_serializer: ProductSerializer,
           meta: { status: 'success', code: 200 },
           status: :ok
  end
end
