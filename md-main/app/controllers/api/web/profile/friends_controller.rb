class Api::Web::Profile::FriendsController < Api::Web::Profile::ApplicationController
  def index
    friends = Friends::FriendsFinder.new(current_dreamer.friends).
              filter(params).
              page(page).per(per_page)

    render json: friends,
           root: :friends,
           meta: { status: 'success', code: 200 }.merge(pagination_meta_for(friends)),
           status: :ok
  end

  def destroy
    friend = Dreamer.find params[:id]

    Relations::RemoveFriend.call current_dreamer, friend

    render json: { meta: { status: 'success', code: 200,
                           message: t('notice.friendship.removed') } },
           status: :ok
  end
end
