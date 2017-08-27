class Api::V1::Profile::FriendshipRequestsController < Api::V1::Profile::ApplicationController
  def index
    requests = FriendRequests::FriendRequestsFinder.new(current_dreamer).
               filter(params).
               page(page).per(per_page)

    render json: requests,
           root: :friendship_requests,
           meta: { status: 'success', code: 200 }.merge(pagination_meta_for(requests)),
           status: :ok
  end

  def create
    result = Relations::SendFriendRequest.call(from: current_dreamer, to: dreamer)

    if result.success?
      render json: result.data,
             root: :friendship_request,
             meta: { status: 'success', code: 200, message: t('api.success.create') },
             status: :ok
    else
      render_unprocessable_entity errors: result.error
    end
  end

  def destroy
    current_dreamer.outgoing_friend_requests.where(receiver: dreamer).destroy_all

    render_success message: t('api.success.destroy')
  end

  def accept
    Relations::AcceptFriendRequest.call dreamer, current_dreamer

    render_success message: t('api.success.create')
  end

  def reject
    Relations::RejectFriendRequest.call dreamer, current_dreamer

    render_success message: t('api.success.destroy')
  end

  private

  def dreamer
    @dreamer ||= Dreamer.find params[:id]
  end
end
