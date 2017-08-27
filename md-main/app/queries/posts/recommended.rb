module Posts
  class Recommended
    attr_reader :dreamer, :params

    def initialize(dreamer, params)
      @dreamer = dreamer
      @params = params
    end

    def fetch
      PostsFinder.new(dreamer).
        filter(include_self_posts: true).
        joins(:likes).
        where(likes: { dreamer_id: dreamer_ids }).
        order('likes.created_at DESC')
    end

    def self.fetch(*args)
      new(*args).fetch
    end

    private

    def dreamer_ids
      case params[:source]
      when 'subscriptions'
        dreamer.speaker_ids
      else
        dreamer.id
      end
    end
  end
end
