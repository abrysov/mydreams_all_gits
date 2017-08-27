class ExtraDreamersController < ApplicationController
  before_action :authenticate_dreamer!

  def destroy
    Relations::RemoveFriend.call current_dreamer, dreamer

    redirect_to :back, notice: I18n.t('notice.friendship.removed')
  end

  def request_friendship
    result = Relations::SendFriendRequest.call from: current_dreamer, to: dreamer

    if result.success?
      flash[:notice] = 'Запрос успешно отправлен'
    else
      flash[:alert] = result.error
    end

    redirect_to :back
  end

  def remove_subscription
    Relations::Unfollow.call current_dreamer, dreamer

    redirect_to :back
  end

  # TODO: rename it later
  def remove_inverse_subscription
    Relations::Unfollow.call dreamer, current_dreamer

    redirect_to :back
  end

  # TODO: refactor to separate actions
  def deny_request
    # NOTE: if I sent request and receiver doesn't processed it - remove request
    # NOTE: if I pressed 'Move to subscribers' button - reject request and leave
    # dreamer in subscribers
    friend_request = current_dreamer.outgoing_friend_requests.find_by receiver: dreamer
    if friend_request
      friend_request.destroy
    elsif current_dreamer.friend_requests.find_by sender: dreamer
      Relations::RejectFriendRequest.call dreamer, current_dreamer
    end

    redirect_to :back
  end

  def accept_request
    Relations::AcceptFriendRequest.call dreamer, current_dreamer

    redirect_to :back
  end

  def subscribe
    result = Relations::Follow.call current_dreamer, dreamer
    if result.success?
      notice = I18n.t('notice.subscription.subscribed')
    else
      notice = result.error
    end

    redirect_to :back, notice: notice
  end

  def unsubscribe
    Relations::Unfollow.call current_dreamer, dreamer

    redirect_to :back, notice: I18n.t('notice.subscription.removed')
  end

  private

  def dreamer
    @dreamer ||= Dreamer.find(params[:id])
  end
end
