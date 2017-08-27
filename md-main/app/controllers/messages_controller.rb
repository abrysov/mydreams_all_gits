class MessagesController < ApplicationController
  before_filter :authenticate_dreamer!

  def index
    ids = [current_dreamer.id, params[:dreamer_id].to_i].sort
    conversation = Conversation.find_by!('member_ids = ARRAY[?]', ids)
    @dreamer = Dreamer.find_by(id: params[:dreamer_id]) ||
      DeletedDreamer.new(id: params[:dreamer_id])

    @messages = conversation
      .messages
      .order(created_at: :desc)
      .page(params[:page])
      .per(10)

    @message = BuildMessage.call(
      from: current_dreamer,
      to: @dreamer,
      message_params: message_params
    )

    if params[:page]
      last_page = { last_page: true }.to_json

      if @messages.total_pages >= @messages.current_page
        render partial: 'messages/messages',
          layout: false,
          locals: { dreamer: @dreamer, messages: @messages }
      elsif @messages.total_pages < @messages.current_page
        render json: last_page
      end
    else
      render 'messages/index',
        layout: false,
        locals: { dreamer: @dreamer, message: @message, modal: params[:modal_msg] ? true : false }
    end

    @messages.update_all(read: true)
  end

  def create
    @dreamer = Dreamer.find_by(id: params[:dreamer_id]) ||
      DeletedDreamer.new(id: params[:dreamer_id])

    @message = BuildMessage.call(
      from: current_dreamer,
      to: @dreamer,
      message_params: message_params
    )

    if @message.save
      @message.conversation.touch
      if params[:message][:files]
        params[:message][:files].each do |file_param|
          @message.attachments.build(file: file_param).save
        end
      end
      render partial: 'messages/message',
        layout: false,
        locals: { dreamer: @dreamer, message: @message }
    else
      render json: { errors: 1 }
    end
  end

  private

  def message_params
    return {} if params[:message].blank?
    params.require(:message).permit(:message)
  end
end
