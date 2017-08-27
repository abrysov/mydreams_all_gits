class Account::MailController < Account::ApplicationController
  before_filter :load_dreamer, only: [:index]

  def index
    @all_my_conversations = current_dreamer.conversations
      .order(updated_at: :desc)
      .page(params[:page])
      .per(8)

    render layout: (request.xhr? ? false : 'flybook')
  end
end
