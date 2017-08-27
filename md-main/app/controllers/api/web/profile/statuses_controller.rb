class Api::Web::Profile::StatusesController < Api::Web::Profile::ApplicationController
  def show
    render json: {
      meta: {
        status: 'success',
        code: 200
      },
      dreamer: {
        id: current_dreamer.id,
        coins_count: current_dreamer.account.amount.to_i,
        messages_count: current_dreamer.new_messages.count,
        notifications_count: current_dreamer.activities.count,
        friend_requests_count: current_dreamer.friend_requests.count
      }
    }, status: :ok
  end
end
