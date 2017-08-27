module Posts
  class PostsFinder
    attr_reader :dreamer, :scope

    def initialize(dreamer, scope = nil)
      @dreamer = dreamer
      @scope = scope || Post
    end

    def filter(**opts)
      @scope = @scope.all_for(dreamer, opts[:include_self_posts]).not_deleted
      @scope = @scope.search(opts[:search]) if opts[:search].present?
      @scope
    end
  end
end
