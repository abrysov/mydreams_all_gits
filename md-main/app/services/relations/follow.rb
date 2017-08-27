module Relations
  class Follow
    attr_reader :dreamer, :another_dreamer

    def initialize(dreamer, another_dreamer)
      @dreamer = dreamer
      @another_dreamer = another_dreamer
    end

    def call
      return invalid_dreamers_error if invalid_dreamers?
      return follows_already_error if follows_already?

      dreamer.subscribe_to(another_dreamer)

      Result::Success.new
    end

    def self.call(*args)
      new(*args).call
    end

    private

    def invalid_dreamers?
      dreamer == another_dreamer
    end

    def invalid_dreamers_error
      Result::Error.new I18n.t('relations.errors.invalid_dreamer')
    end

    def follows_already?
      dreamer.followees.exists? another_dreamer.id
    end

    def follows_already_error
      Result::Error.new I18n.t('relations.errors.subscribed_already')
    end
  end
end
