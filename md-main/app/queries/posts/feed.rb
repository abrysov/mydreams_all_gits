module Posts
  class Feed
    attr_reader :dreamer, :scope

    def initialize(dreamer, scope = nil)
      @dreamer = dreamer
      @scope = scope || Post
    end

    def fetch
      PostsFinder.new(dreamer, scope).
        filter(include_self_posts: true).
        where(dreamer_id: dreamer.speaker_ids << dreamer.id).
        order(created_at: :desc)
    end

    def self.fetch(*args)
      new(*args).fetch
    end
  end
end
