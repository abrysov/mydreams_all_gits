class Api::Web::Profile::ConversationsController < Api::Web::Profile::ApplicationController
  def index
    conversations = current_dreamer.
                    conversations.
                    order(updated_at: :desc).
                    page(page).
                    per(per_page)

    render json: conversations,
           each_serializer: ConversationSerializer,
           scope: current_dreamer,
           meta: { status: 'success', code: 200 }.merge(pagination_meta_for(conversations)),
           status: :ok
  end

  def create
    to_dreamer = Dreamer.not_deleted.not_blocked.find(params[:id])
    ids = [current_dreamer.id, to_dreamer.id].sort
    conversation = Conversation.where('member_ids = ARRAY[?]', ids).
                   first_or_create(member_ids: ids)

    conversation.touch

    render json: conversation,
           serializer: ConversationSerializer,
           meta: { status: 'success', code: 200 },
           status: :ok
  end
end
