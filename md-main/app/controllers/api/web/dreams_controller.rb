class Api::Web::DreamsController < Api::Web::ApplicationController
  before_filter :authenticate_dreamer!, only: [:create, :update, :destroy]

  def index
    dreams = Dreams::DreamsFinder.new.
             filter(params, current_dreamer).
             page(page).
             per(per_page).
             preload(:certificates, :dreamer)

    render json: dreams,
           meta: { status: 'success', code: 200 }.merge(pagination_meta_for(dreams)),
           status: :ok
  end

  def create
    form = NewDreamForm.new(dreamer: current_dreamer, params: dream_params)

    if form.save
      new_dream = form.dream
      ::Feed::Activity::Create.call(owner: current_dreamer, trackable: new_dream, key: 'dream_create')

      render json: new_dream,
             meta: { status: 'success', code: 200, message: t('api.success.dream_create') },
             status: :ok
    else
      render json: {
        meta: { status: 'fail', code: 400, message: t('api.failure.unprocessable_entity') }
      }, status: :unprocessable_entity
    end
  end

  def show
    dream = Dream.not_deleted.all_for(current_dreamer).find(params[:id])

    render json: dream,
           serializer: DetailedDreamSerializer,
           include: '**',
           meta: { status: 'success', code: 200, message: t('api.success.search') },
           status: :ok
  end

  def update
    dream = current_dreamer.dreams.find(params[:id])
    dream.attributes = dream_params

    if dream.save
      render json: dream,
             meta: { status: 'success', code: 200, message: t('api.success.search') },
             status: :ok
    else
      render json: {
        meta: { status: 'fail', code: 422, message: t('api.failure.unprocessable_entity'),
                errors: dream.errors.full_messages }
      }, status: :unprocessable_entity
    end
  end

  def destroy
    dream = current_dreamer.dreams.find(params[:id])

    dream.mark_deleted

    render json: { meta: { status: 'success', code: 200, message: t('api.success.destroy') } },
           status: :ok
  end

  private

  def dream_params
    params[:restriction_level] = restriction params[:restriction_level]
    params.permit(:title, :description, :photo, :restriction_level, :came_true,
                  photo_crop: [:x, :y, :width, :height])
  end
end
