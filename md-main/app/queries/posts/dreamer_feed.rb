module Posts
  class DreamerFeed
    attr_reader :current_dreamer, :dreamer, :scope

    def initialize(current_dreamer, dreamer, scope = nil)
      @dreamer = dreamer
      @current_dreamer = current_dreamer
      @scope = scope || Post
    end

    def fetch
      PostsFinder.new(current_dreamer, scope).
        filter(include_self_posts: false).
        where(dreamer_id: dreamer.id).
        order(created_at: :desc)
    end

    def self.fetch(*args)
      new(*args).fetch
    end
  end
end
