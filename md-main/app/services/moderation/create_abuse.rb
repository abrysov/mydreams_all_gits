module Moderation
  class CreateAbuse
    def initialize(moderator:, abusable:, text:)
      @moderator = moderator
      @abusable = abusable
      @notifyer = dreamer_of_object(abusable)
      @text = text
    end

    def call
      ActiveRecord::Base.transaction do
        @abuse = Abuse.create!(
          moderator_id: @moderator.id,
          notify_id: @notifyer.id,
          abusable: @abusable,
          text: @text
        )

        LogAction::Moderation.call('create', @abuse, @moderator)

        @message = BuildMessage.call(
          from: Dreamer.project_moderator,
          to: @notifyer,
          message_params: { message: @text }
        )

        @message.save!
        @message.conversation.touch
      end
      @abuse
    end

    def self.call(*args)
      new(*args).call
    end

    private

    def dreamer_of_object(object)
      object.is_a?(Dreamer) ? object : object.dreamer
    end
  end
end
