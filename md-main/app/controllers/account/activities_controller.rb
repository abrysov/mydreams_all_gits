class Account::ActivitiesController < Account::ApplicationController
  before_action :load_dreamer, only: [:index]

  def index
    @activities = @dreamer.friends_feed.
                  filter(params[:filter] || {}).
                  order(updated_at: :desc).
                  page(params[:page]).per(10)

    @activities.not_viewed.update_all(viewed: true)

    render layout: (request.xhr? ? false : 'flybook')
  end
end
