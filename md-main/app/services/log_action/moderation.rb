module LogAction
  class Moderation
    def initialize(action, logable, moderator)
      @action = action
      @logable = logable
      @moderator = moderator
    end

    def call
      ModeratorLog.create(
        action: @action,
        logable: @logable,
        dreamer: @moderator
      )
    end

    def self.call(*args)
      new(*args).call
    end
  end
end
