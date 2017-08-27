class Api::V1::Profile::ConversationsController < Api::V1::Profile::ApplicationController
  def index
    conversations = current_dreamer.
                    conversations.
                    order(updated_at: :desc).
                    page(page).
                    per(per_page)

    render json: conversations,
           each_serializer: ConversationSerializer,
           meta: { status: 'success', code: 200 }.merge(pagination_meta_for(conversations)),
           status: :ok
  end
end
