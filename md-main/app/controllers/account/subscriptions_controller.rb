class Account::SubscriptionsController < Account::ApplicationController
  skip_before_action :authenticate_dreamer!, only: [:index]
  after_action :mark_new_followers!, only: :index

  def index
    @dreamer = DreamerDecorator.decorate Dreamer.find params[:dreamer_id]
    @received_followers = @dreamer.new_followers

    if params[:subscriptions]
      @subscriptions  = @dreamer.followees
                        .page(params[:page]).per(16)
                        .includes(:dream_city)

      partial = 'subscriptions'
    else
      per_page = (current_dreamer?(@dreamer) && @dreamer.flybook_nb_new_followers > 0) ? 12 : 16
      displayed_followers = current_dreamer?(@dreamer) ? @dreamer.viewed_followers : @dreamer.followers

      @followers = Dreamers::DreamersFinder.new(displayed_followers).
                   filter(params).
                   page(params[:page]).
                   per(per_page).
                   includes(:dream_city)

      partial = 'followers'
    end

    render "account/subscriptions/#{partial}", layout: (request.xhr? ? false : 'flybook')
  end

  def show_received_followers
    @dreamer = DreamerDecorator.decorate Dreamer.find params[:dreamer_id]
    @received_followers = @dreamer.new_followers

    render partial: 'account/subscriptions/followers/all_received_followers', layout: false

    if current_dreamer?(@dreamer)
      @dreamer.passive_followings.unviewed.update_all(view_state: 'viewed')
    end
  end

  private

  def mark_new_followers!
    return if params[:subscriptions]

    if current_dreamer?(@dreamer) && @dreamer.new_followers.count > 0
      @dreamer.passive_followings.unviewed.last(4).each(&:view!)
    end
  end
end
