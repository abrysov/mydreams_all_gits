class Api::ApplicationController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  private

  def page
    [params[:page].to_i, 1].max
  end

  def per_page
    per = params[:per].to_i
    per <= 0 ? 10 : per
  end

  def restriction(level)
    case level
    when 'private' then 2
    when 'friends' then 1
    when 'public'  then 0
    else 0
    end
  end

  def render_not_found
    render json: { meta: { status: 'fail', code: 404, message: t('api.failure.not_found') } },
           status: :not_found
  end

  def render_forbidden
    render json: { meta: { status: 'fail', code: 403, message: t('api.failure.forbidden') } },
           status: :forbidden
  end

  def render_unprocessable_entity(errors: nil)
    render json: { meta: { status: 'fail', code: 422,
                           message: t('api.failure.unprocessable_entity'),
                           errors: errors } },
           status: :unprocessable_entity
  end

  def render_success(message: :nil)
    render json: { meta: { status: 'success', code: 200, message: message } },
           status: :ok
  end

  def pagination_meta_for(collection)
    current_page = collection.current_page # page
    total_count  = collection.total_count
    total_pages  = collection.total_pages
    per = per_page

    remaining_count = total_count - per_page * current_page
    remaining_count = 0 if remaining_count < 0

    {
      total_count: total_count, pages_count: total_pages, remaining_count: remaining_count,
      per: per, page: current_page
    }
  end
end
