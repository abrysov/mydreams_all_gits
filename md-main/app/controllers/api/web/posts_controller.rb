class Api::Web::PostsController < Api::Web::ApplicationController
  def index
    posts = Posts::PostsFinder.new(current_dreamer).
            filter(search: params[:q]).
            page(page).
            per(per_page)

    render json: posts,
           include: '**',
           meta: { status: 'success',
                   code: 200,
                   message: t('api.success.search') }.merge(pagination_meta_for(posts)),
           status: :ok
  end

  def create
    post = current_dreamer.posts.new(post_params)

    if post.save
      if params_post_photos_ids
        post.photos << PostPhoto.where(id: params_post_photos_ids, dreamer: current_dreamer)
      end

      render json: post,
             include: '**',
             meta: { status: 'success', code: 200, message: t('api.success.create') }, status: :ok
    else
      message = t('api.failure.unprocessable_entity')
      render json: { meta: { status: 'fail', code: 422, message: message,
                             errors: post.errors.full_messages } },
             status: :unprocessable_entity
    end
  end

  def show
    post = Posts::PostsFinder.new(current_dreamer).filter.find(params[:id])

    render json: post,
           include: '**',
           meta: { status: 'success', code: 200, message: t('api.success.search') },
           status: :ok
  end

  def update
    post = current_dreamer.posts.find(params[:id])
    post.attributes = post_params

    if post.save
      if params_post_photos_ids
        new_ids = params_post_photos_ids - post.photo_ids
        removed_ids = post.photo_ids - params_post_photos_ids
        post.photos << PostPhoto.where(id: new_ids, dreamer: current_dreamer)
        post.photos.where(id: removed_ids).destroy_all
      end

      render json: post,
             include: '**',
             meta: { status: 'success', code: 200, message: t('api.success.search') }, status: :ok
    else
      message = t('api.failure.unprocessable_entity')
      render json: { meta: { status: 'fail', code: 422, message: message,
                             errors: post.errors.full_messages } },
             status: :unprocessable_entity
    end
  end

  def destroy
    current_dreamer.posts.where(id: params[:id]).destroy_all
    render json: { meta: { status: 'success', code: 200 } }, status: :ok
  end

  private

  def params_post_photos_ids
    params[:post_photos_ids].reject(&:blank?).map(&:to_i) if params[:post_photos_ids]
  end

  def post_params
    params.permit(:content, :restriction_level)
  end
end
